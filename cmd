#
sudo apt update -y
sudo apt install azure-cli -y
npm i -g azure-functions-core-tools@4 --unsafe-perm true
func init ImageResizeFunc --python
cd ImageResizeFunc
func new --name ResizeImageFunction --template "Blob trigger" --authlevel "function"

ImageResizeFunc/
├── host.json
├── requirements.txt
├── ResizeImageFunction/
│   ├── __init__.py
│   ├── function.json
└── local.settings.json (optional)

az storage account create --name ranjethsafuncapp123 --location eastus2 --resource-group ranjethrg --sku Standard_LRS

az functionapp create \
  --resource-group ranjethrg \
  --consumption-plan-location eastus2 \
  --runtime python \
  --functions-version 4 \
  --name ranjethfa \
  --storage-account ranjethsafuncapp123 \
  --os-type Linux \
  --runtime-version 3.11

az storage account show-connection-string --name ranjethsaorg --resource-group ranjethrg -o tsv
az storage account show-connection-string --name ranjethsadest --resource-group ranjethrg -o tsv

az functionapp config appsettings set --name ranjethfa --resource-group ranjethrg --settings \
  AzureWebJobsStorage="DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=ranjethsaorg;AccountKey=nuBJvUvj3oQbNXO6Cjokm1iBQMEHKjZQZ2i85TIq+VPPPH1T5I4b207B2uEgLtelk4ZFejt8wEY5+ASttSCM1Q==;BlobEndpoint=https://ranjethsaorg.blob.core.windows.net/;FileEndpoint=https://ranjethsaorg.file.core.windows.net/;QueueEndpoint=https://ranjethsaorg.queue.core.windows.net/;TableEndpoint=https://ranjethsaorg.table.core.windows.net/" \
  DEST_STORAGE_CONNECTION="DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=ranjethsadest;AccountKey=NhBc4eCaGrtvpgkxxqH6wmbGBeKmLL3o6RIpNsxK33Wbd4DwmrFioS7L2XuihGzESOBIOqHdVbmz+AStbMPTZg==;BlobEndpoint=https://ranjethsadest.blob.core.windows.net/;FileEndpoint=https://ranjethsadest.file.core.windows.net/;QueueEndpoint=https://ranjethsadest.queue.core.windows.net/;TableEndpoint=https://ranjethsadest.table.core.windows.net/"


func azure functionapp publish ranjethfa --python --build remote