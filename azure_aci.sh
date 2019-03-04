# Deploy a single container instance using the Azure Container Instance (ACI) Service.

$ az group create --name acidemo-rg --location southeastasia
$ az container create -g acidemo-rg --name nginx --image microsoft/aci-helloworld --os-type linux --cpu 2 --memory 7 \
  --ip-address public --ports 80 443 --dns-name-label acidemo --restart-policy OnFailure

echo "http://acidemo.southeastasia.azurecontainer.io/"

# Display the IP Address
$ az container list -g acidemo-rg -o table

# Show container status
$ az container show --resource-group acidemo-rg --name nginx --query containers[0].instanceView.currentState.state
"Running"

# View logfiles
$ az container logs --resource-group acidemo-rg --name nginx
listening on port 80

# Monitor metrics from container, run on ACI
$ CONTAINER_GROUP=$(az container show --resource-group acidemo-rg --name nginx --query id --output tsv)
$ az monitor metrics list --resource $CONTAINER_GROUP --metric CPUUsage --output table
$ az monitor metrics list --resource $CONTAINER_GROUP --metric MemoryUsage --output table

# You can set Environment Variables for the container, providing dynamic condfiguration
```
$ az container create \
    --resource-group myResourceGroup \
    --name mycontainer2 \
    --image microsoft/aci-wordcount:latest \
    --restart-policy OnFailure \
    --environment-variables NumWords=5 MinLength=8
```

# Command-line over-ride - similar to docker entrypoint
```
az container create \
    --resource-group myResourceGroup \
    --name mycontainer3 \
    --image microsoft/aci-wordcount:latest \
    --restart-policy OnFailure \
    --environment-variables NumWords=3 MinLength=5 \
    --command-line "python wordcount.py http://shakespeare.mit.edu/romeo_juliet/full.html"
```

# Clean-up
$ az container delete --name nginx -g acidemo-rg --yes
$ az group delete --name acidemo-rg --no-wait --yes

# More info :
# https://azure.microsoft.com/en-us/blog/azure-container-instances-now-generally-available/
# https://azure.microsoft.com/en-us/services/container-instances/
# https://azure.microsoft.com/en-us/updates/aci-feb/
# https://docs.microsoft.com/en-us/azure/container-instances/container-instances-jenkins

# Various volume types for Linux containers including Azure Files, gitRepo, emptyDir, and secret


# Azure Container Instances as SOCKS proxy
*https://gist.github.com/noelbundick/be9bf7bcaa6c6bcee4b65da841c620a3#file-proxy-sh
*The ltsc2019 Windows container base image is not supported in ACI
