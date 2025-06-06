import logging
import os
from io import BytesIO
from PIL import Image
import azure.functions as func
from azure.storage.blob import BlobServiceClient

# Destination Storage Account connection string
DEST_CONN_STR = os.getenv("DEST_STORAGE_CONNECTION")

def main(inputBlob: func.InputStream):
    logging.info(f"Python blob trigger function processed blob \n"
                 f"Name: {inputBlob.name}\n"
                 f"Blob Size: {inputBlob.length} bytes")

    # Check file extension
    filename = os.path.basename(inputBlob.name)
    ext = filename.split('.')[-1].lower()
    if ext not in ['png', 'jpeg', 'jpg']:
        logging.info("Unsupported file type, skipping processing.")
        return

    # Open image from blob
    image = Image.open(inputBlob)

    # Resize image (example: max 800x800)
    image.thumbnail((800, 800))

    # Save to BytesIO
    output_stream = BytesIO()
    image_format = 'JPEG' if ext in ['jpeg', 'jpg'] else 'PNG'
    image.save(output_stream, format=image_format)
    output_stream.seek(0)

    # Upload resized image to destination storage account
    blob_service_client = BlobServiceClient.from_connection_string(DEST_CONN_STR)
    container_client = blob_service_client.get_container_client("processed-image")

    # Upload blob, overwrite if exists
    container_client.upload_blob(name=filename, data=output_stream, overwrite=True)

    logging.info(f"Resized image uploaded to 'processed-image' container with name {filename}")