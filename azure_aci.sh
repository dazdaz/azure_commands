# Deploy a single container instance using the Azure Container Instance (ACI) Service.

$ az group create --name acidemo --location southeastasia
$ az container create -g acidemo --name nginx --image microsoft/aci-helloworld --os-type linux --cpu 2 --memory 7 \
  --ip-address public --ports 80 443 --dns-name-label acidemo --restart-policy Never

echo "http://acidemo.southeastasia.azurecontainer.io/"

# Monitor metrics from container, run on ACI
$ CONTAINER_GROUP=$(az container show --resource-group acidemo --name nginx --query id --output tsv)
$ az monitor metrics list --resource $CONTAINER_GROUP --metric CPUUsage --output table
$ az monitor metrics list --resource $CONTAINER_GROUP --metric MemoryUsage --output table

# Display the IP Address
az container list -g acidemo -o table
az container delete --name nginx -g acidemo --yes
az group delete --name acidemo --no-wait --yes

# More info :
# https://azure.microsoft.com/en-us/blog/azure-container-instances-now-generally-available/
# https://azure.microsoft.com/en-us/services/container-instances/
# https://azure.microsoft.com/en-us/updates/aci-feb/

# Various volume types for Linux containers including Azure Files, gitRepo, emptyDir, and secret
