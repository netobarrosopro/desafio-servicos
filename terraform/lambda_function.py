import boto3
import datetime

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Gera o nome do arquivo com data/hora exata
    current_time = datetime.datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    file_name = f"upload_{current_time}.txt"
    
    # Conteúdo do arquivo (exemplo simples)
    file_content = f"Arquivo gerado em: {datetime.datetime.utcnow().isoformat()}"
    
    # Upload para o S3
    s3.put_object(
        Bucket=event['S3_BUCKET'],  # Pegar do environment variable
        Key=file_name,
        Body=file_content,
        ACL='private'  # Ou 'public-read' se quiser público
    )
    
    return {
        'statusCode': 200,
        'body': f"Arquivo {file_name} criado com sucesso no bucket {event['S3_BUCKET']}"
    }