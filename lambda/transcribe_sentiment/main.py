import boto3
import json
import os
import time
import logging
import requests
from datetime import datetime

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients
transcribe = boto3.client('transcribe')
comprehend = boto3.client('comprehend')
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

# Environment variables with defaults
MEDIA_FORMAT = os.environ.get('MEDIA_FORMAT', 'mp3')
LANGUAGE_CODE = os.environ.get('LANGUAGE_CODE', 'en-US')
COMPREHEND_LANGUAGE_CODE = os.environ.get('COMPREHEND_LANGUAGE_CODE', 'en')
DYNAMODB_TABLE_NAME = os.environ.get('DYNAMODB_TABLE_NAME', 'Transcriptions')
RESULTS_S3_BUCKET = os.environ.get('RESULTS_S3_BUCKET', '')
TRANSCRIPTION_POLL_INTERVAL = int(os.environ.get('TRANSCRIPTION_POLL_INTERVAL', '5'))
MAX_TRANSCRIPTION_WAIT_TIME = int(os.environ.get('MAX_TRANSCRIPTION_WAIT_TIME', '300'))


def lambda_handler(event, context):
    """
    Lambda handler for processing S3 events and performing transcription and sentiment analysis.
    
    Expected environment variables:
    - MEDIA_FORMAT: Audio/video format (default: 'mp3')
    - LANGUAGE_CODE: Transcription language code (default: 'en-US')
    - COMPREHEND_LANGUAGE_CODE: Comprehend language code (default: 'en')
    - DYNAMODB_TABLE_NAME: DynamoDB table name for storing results (default: 'Transcriptions')
    - RESULTS_S3_BUCKET: S3 bucket for storing transcription results (optional)
    - TRANSCRIPTION_POLL_INTERVAL: Seconds between polling transcription status (default: 5)
    - MAX_TRANSCRIPTION_WAIT_TIME: Maximum seconds to wait for transcription (default: 300)
    """
    logger.info(f'Processing S3 event: {json.dumps(event)}')
    
    try:
        # Extract S3 event details
        if not event.get('Records') or len(event['Records']) == 0:
            logger.error('No S3 records found in event')
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'No S3 records found in event'})
            }
        
        record = event['Records'][0]
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        job_name = os.path.splitext(os.path.basename(key))[0]  # Use filename without extension
        file_uri = f's3://{bucket}/{key}'
        
        logger.info(f'Processing file: {file_uri}, Job name: {job_name}')
        
        # Start transcription job
        try:
            transcribe.start_transcription_job(
                TranscriptionJobName=job_name,
                Media={'MediaFileUri': file_uri},
                MediaFormat=MEDIA_FORMAT,
                LanguageCode=LANGUAGE_CODE
            )
            logger.info(f'Started transcription job: {job_name}')
        except transcribe.exceptions.ConflictException:
            logger.warning(f'Transcription job {job_name} already exists. Checking status...')
        except Exception as e:
            logger.error(f'Failed to start transcription job: {str(e)}')
            raise
        
        # Wait for the job to complete with timeout
        job_status = None
        start_time = time.time()
        
        while True:
            try:
                status = transcribe.get_transcription_job(TranscriptionJobName=job_name)
                job_status = status['TranscriptionJob']['TranscriptionJobStatus']
                logger.info(f'Transcription job {job_name} status: {job_status}')
                
                if job_status in ['COMPLETED', 'FAILED']:
                    break
                
                # Check for timeout
                elapsed_time = time.time() - start_time
                if elapsed_time > MAX_TRANSCRIPTION_WAIT_TIME:
                    logger.error(f'Transcription job {job_name} timed out after {elapsed_time} seconds')
                    job_status = 'TIMED_OUT'
                    break
                
                time.sleep(TRANSCRIPTION_POLL_INTERVAL)
            except Exception as e:
                logger.error(f'Error checking transcription job status: {str(e)}')
                raise
        
        if job_status == 'COMPLETED':
            try:
                # Retrieve transcript
                transcript_uri = status['TranscriptionJob']['Transcript']['TranscriptFileUri']
                logger.info(f'Retrieving transcript from: {transcript_uri}')
                
                response = requests.get(transcript_uri, timeout=30)
                response.raise_for_status()
                transcript_data = response.json()
                transcript = transcript_data['results']['transcripts'][0]['transcript']
                
                logger.info(f'Transcript retrieved successfully. Length: {len(transcript)} characters')
                
                # Perform sentiment analysis
                sentiment_response = comprehend.detect_sentiment(
                    Text=transcript,
                    LanguageCode=COMPREHEND_LANGUAGE_CODE
                )
                sentiment = sentiment_response['Sentiment']
                sentiment_score = sentiment_response['SentimentScore']
                
                logger.info(f'Sentiment analysis complete. Sentiment: {sentiment}')
                
                # Prepare result data
                result_data = {
                    'JobName': job_name,
                    'SourceFile': file_uri,
                    'Transcript': transcript,
                    'Sentiment': sentiment,
                    'SentimentScore': sentiment_score,
                    'ProcessedAt': datetime.utcnow().isoformat(),
                    'MediaFormat': MEDIA_FORMAT,
                    'LanguageCode': LANGUAGE_CODE
                }
                
                # Store results in DynamoDB
                try:
                    table = dynamodb.Table(DYNAMODB_TABLE_NAME)
                    table.put_item(Item=result_data)
                    logger.info(f'Results stored in DynamoDB table: {DYNAMODB_TABLE_NAME}')
                except Exception as e:
                    logger.error(f'Failed to store results in DynamoDB: {str(e)}')
                    # Continue execution even if DynamoDB write fails
                
                # Store results in S3 (if bucket is configured)
                if RESULTS_S3_BUCKET:
                    try:
                        s3_key = f'transcriptions/{job_name}.json'
                        s3.put_object(
                            Bucket=RESULTS_S3_BUCKET,
                            Key=s3_key,
                            Body=json.dumps(result_data, indent=2),
                            ContentType='application/json'
                        )
                        logger.info(f'Results stored in S3: s3://{RESULTS_S3_BUCKET}/{s3_key}')
                    except Exception as e:
                        logger.error(f'Failed to store results in S3: {str(e)}')
                        # Continue execution even if S3 write fails
                
                return {
                    'statusCode': 200,
                    'body': json.dumps({
                        'message': 'Transcription and sentiment analysis complete',
                        'jobName': job_name,
                        'sentiment': sentiment,
                        'resultLocation': {
                            'dynamodbTable': DYNAMODB_TABLE_NAME,
                            's3Bucket': RESULTS_S3_BUCKET if RESULTS_S3_BUCKET else None
                        }
                    })
                }
                
            except requests.RequestException as e:
                logger.error(f'Error retrieving transcript: {str(e)}')
                return {
                    'statusCode': 500,
                    'body': json.dumps({'error': f'Failed to retrieve transcript: {str(e)}'})
                }
            except Exception as e:
                logger.error(f'Error processing transcript: {str(e)}')
                raise
        
        elif job_status == 'FAILED':
            failure_reason = status['TranscriptionJob'].get('FailureReason', 'Unknown error')
            logger.error(f'Transcription job failed: {failure_reason}')
            return {
                'statusCode': 500,
                'body': json.dumps({
                    'error': 'Transcription job failed',
                    'jobName': job_name,
                    'failureReason': failure_reason
                })
            }
        else:
            logger.error(f'Transcription job ended with unexpected status: {job_status}')
            return {
                'statusCode': 500,
                'body': json.dumps({
                    'error': 'Transcription job did not complete successfully',
                    'jobName': job_name,
                    'status': job_status
                })
            }
    
    except KeyError as e:
        logger.error(f'Missing required field in event: {str(e)}')
        return {
            'statusCode': 400,
            'body': json.dumps({'error': f'Invalid event structure: {str(e)}'})
        }
    except Exception as e:
        logger.error(f'Unexpected error processing S3 event: {str(e)}', exc_info=True)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': f'Internal server error: {str(e)}'})
        }
