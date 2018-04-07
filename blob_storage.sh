#!/bin/bash

# Pulled info out of these documents :

# https://docs.microsoft.com/gl-es/azure/storage/scripts/storage-blobs-container-calculate-size-cli
# https://docs.microsoft.com/gl-es/azure/storage/scripts/storage-common-rotate-account-keys-cli
# https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli

# https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction
# Blob = Blobs are basically files.
# Container = Blobs are stored in containers, which are similar to folders.

LOCATION=southeastasia
RG=myblob1-rg
AZURE_STORAGE_ACCOUNT=myacct1mystorage
AZURE_BLOBNAME=mystorageblob1
AZURE_CONTAINER=mycontainer

# create a resource group
az group create --name $RG --location $LOCATION

# Blob EndPoint: https://${AZURE_BLOBNAME}.blob.core.windows.net/${AZURE_CONTAINER}
# Create a general-purpose standard storage BLOB
az storage account create \
    --name $AZURE_STORAGE_ACCOUNT \
    --resource-group $RG \
    --location $LOCATION \
    --sku Standard_RAGRS \
    --encryption blob

# List the BLOBs
az storage blob list --container-name $AZURE_CONTAINER --output table

# List the storage account access keys
az storage account keys list \
    --resource-group $RG \
    --account-name $AZURE_BLOBNAME

AZURE_STORAGE_PRIMARY_KEY=$(az storage account keys list --resource-group $RG --account-name $AZURE_BLOBNAME --query '[0].value')

# MyConectionString=$(az storage account show-connection-string -g MyRG -n DemoSA)
## Saves for the current session
# export AZURE_STORAGE_CONNECTION_STRING="$MyConnectionString"

# Create a container (folder)
# off (default): Container data is private to the account owner.
# blob: Public read access for blobs.
# container: Public read and list access to the entire container.
az storage container create --name $AZURE_CONTAINER --public-access blob

# List the containers (folders)
az storage container list
az storage container list --query '[*].{name: name}' --account-name $AZURE_BLOBNAME --account-key $AZURE_STORAGE_ACCESS_KEY

# Upload a file into the Azure BLOB
az storage blob upload --container-name $AZURE_CONTAINER --name $AZURE_BLOBNAME --file "/etc/hosts"

# Upload sample files to container
az storage blob upload-batch \
    --pattern "container_size_sample_file_*.txt" \
    --source . \
    --destination $AZURE_CONTAINER

# Download a Blob(file) from the Container(Folder)
az storage blob download --container-name $AZURE_CONTAINER --name $AZURE_BLOBNAME --file "~/abc"

# Azure Storage Explorer App - Windows|MacOS|Linux
# https://azure.microsoft.com/en-us/features/storage-explorer/

# Remove the container
az storage container delete --name $AZURE_CONTAINER

# Remove the Azure Storage Account
az storage account delete \
    --name $AZURE_STORAGE_ACCOUNT \
    --resource-group $RG \
    --yes

# Remove the RG
az group delete --name $RG --yes
