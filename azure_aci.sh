# Deploy a single container instance using the Azure Container Instance (ACI) Service.

$ az container create -g acidemo --name nginx --image microsoft/aci-helloworld --os-type linux --cpu 1 --memory 1 \
  --ip-address public --ports 80 443 --dns-name-label acidemo

echo "http://acidemo.southeastasia.azurecontainer.io/"

# More onfo :
# https://azure.microsoft.com/en-us/services/container-instances/
# https://azure.microsoft.com/en-us/updates/aci-feb/
