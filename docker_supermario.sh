# Runs SuperMario within a Linux container on a Linux VM

docker run --name mario1 -d -p 8888:8080 pengbai/docker-supermario
az vm open-port --port 8888 --resource-group ubuntu1704rg --name ubuntu1704
curl ifconfig.co
# Connect to http://IP:8888 in your web browser

docker stop mario1
docker rm mario1
