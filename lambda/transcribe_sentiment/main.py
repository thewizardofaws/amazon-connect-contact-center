import boto3
import json
import os
import requests

transcribe = boto3.client('transcribe')
comprehend = boto3.client('comprehend')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    job_name = key.split('.')[0]  # unique job name based on the filename
    file_uri = f's3://{bucket}/{key}'

    try:
        # Start transcription job
        transcribe.start_transcription_job(
            TranscriptionJobName=job_name,
            Media={'MediaFileUri': file_uri},
            MediaFormat='mp3',  # Adjustale format
            LanguageCode='en-US' # Adjustable language code
        )

        # Wait for the job to complete
        while True:
            status = transcribe.get_transcription_job(TranscriptionJobName=job_name)
            job_status = status['TranscriptionJob']['TranscriptionJobStatus']
            if job_status in ['COMPLETED', 'FAILED']:
                break
            print(f"Transcription job status: {job_status}") # Helpful for debugging
            time.sleep(5) # avoid throttling

        if job_status == 'COMPLETED':
            transcript_uri = status['TranscriptionJob']['Transcript']['TranscriptFileUri']
            response = requests.get(transcript_uri)
            transcript_data = response.json()
            transcript = transcript_data['results']['transcripts'][0]['transcript']

            # Perform sentiment analysis
            sentiment_response = comprehend.detect_sentiment(Text=transcript, LanguageCode='en')
            sentiment = sentiment_response['Sentiment']
            sentiment_score = sentiment_response['SentimentScore']

            # Store results (example: printing to console - replace with DynamoDB or S3)
            print(f'Transcription: {transcript}')
            print(f'Sentiment: {sentiment}')
            print(f'Sentiment Score: {sentiment_score}')

            # Consider storing the results in DynamoDB for persistence
            # dynamodb = boto3.resource('dynamodb')
            # table = dynamodb.Table('Transcriptions')
            # table.put_item(Item={
            #     'JobName': job_name,
            #     'Transcript': transcript,
            #     'Sentiment': sentiment,
            #     'SentimentScore': sentiment_score
            # })

            # Consider storing the results in S3 for persistence
            # s3.put_object(
            #     Bucket=os.environ['S3_BUCKET_NAME'],
            #     Key=f'transcriptions/{job_name}.txt',
            #     Body=f'Transcription: {transcript}\nSentiment: {sentiment}\nSentiment Score: {sentiment_score}'
            # )

        else:
            print(f'Transcription failed: {status}')

    except Exception as e:
        print(f'Error processing S3 event: {e}')
        # Add more robust error handling (e.g., send to CloudWatch Logs, notify via SNS)

    return {
        'statusCode': 200,
        'body': json.dumps('Transcription and sentiment analysis complete!')
    }
