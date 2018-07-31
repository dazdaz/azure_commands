# https://docs.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest

ACRREG=myregistry.azurecr.io
ACRADMIN=myregistry
ACRRG=myregistry-rg

az group create --name ${ACRRG} --location southeastasia
az acr create --name ${ACRREG} --sku Standard --resource-group ${ACRRG} --location southeastasia --admin-enabled
az acr show --name ${ACRADMIN} --resource-group ${ACRRG}
# az acr credential show --name ${ACRADMIN} --resource-group ${ACRRG} -o table
ACRPASS=$(az acr credential show --name dazacr --resource-group dazacr-rg --query passwords[0].value -o tsv)

docker login ${ACRREG} -u ${ARCADMIN} -p ${ACRPASS}
docker pull dazdaz/chirp
docker tag content-web ${ACRREG}/chirp/content-web:v1
docker images
docker push ${ACRREG}/chirp/content-web:v1
