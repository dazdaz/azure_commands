<<WIP - Updating this for Postgres>>>

#!/bin/bash

AZLOC=southeastasia
MY_RG=daz-pgsql-rg
PGSQL_NAME=pgsqlserver4demo
DBADMIN=myadmin
DBPASSWORD=ssssssshhhhhhhss
SUBSCRIPTION_ID=1234567890

# https://docs.microsoft.com/en-us/azure/postgresql/
# https://docs.microsoft.com/en-us/azure/postgresql/overview
# https://docs.microsoft.com/en-us/azure/postgresql/howto-configure-server-parameters-using-cli

# Create Azure Resource Group
az group create --name $MY_RG --location $AZLOC --tags AppService=PostgreSQL Environment=Development Owner=bill@microsoft.com

# Create the virtual network "myVNet and subnet"
az network vnet create \
-g m$MY_RG \
-n myVNet \
--address-prefixes 10.0.0.0/16 \
-l $AZLOC

# Create the service endpoint
az network vnet subnet create \
-g $MY_RG \
-n mySubnet \
--vnet-name myVNet \
--address-prefix 10.0.0.1/24 \
--service-endpoints Microsoft.SQL

# Create a VNet rule on the server to secure it to the subnet
az postgres vnet-rule create \
--name $PG_SQL_NAME \
-resource-group $MY_RG \
--server mypgpserver-20180111 \
--subnet mySubnet

# Create Azure PostgreSQL Database of 128GB
az postgres server create --resource-group $MY_RG --name $PGSQL_NAME --location $AZLOC \
  --admin-user brijraj --admin-password windows@123456 \
  --performance-tier Standard \
  --compute-units 100 \
  --version 9.6 \
  --storage-size 128000 \
  --tags Environment=Development Owner=bill@microsoft.com

# View Azure Postgres settings, Host information, i.e. ACU
az postgres server configuration list --resource-group $MY_RG --server $PGSQL_NAME

# Check the value of log_min_messages
az postgres server configuration show \
   --resource-group $MY_RG \
   --server-name $PGSQL_NAME \
   --name log_min_messages

# Set value of log_min_messages
az postgres server configuration set \
   --resource-group $MY_RG \
   --server-name $PGSQL_NAME \
   --name log_min_messages \
   --value INFO

# Configure Azure PostgreSQL
az postgres server firewall-rule create --resource-group $MY_RG --server $PGSQL_NAME --name AllowAll --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
az postgres server update -g $MY_RG -n $PGSQL_NAME --ssl-enforcement Disabled

psql -U postgres --host ${PGSQL_NAME}.postgres.database.azure.com

CREATE DATABASE demodb1 WITH OWNER demorole1 ENCODING 'UTF8';
USE demodb1;
CREATE TABLE editorial (id INT, name VARCHAR(20), email VARCHAR(20));
SHOW tables;
INSERT INTO editorial (id,name,email) VALUES(01,"Olivia","olivia@company.com");
SELECT * FROM editorial;

# Display CPU Metrics over a set timeframe
az monitor metrics list --resource "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${MY_RG}/providers/Microsoft.DBforMySQL/servers/${PGSQL_NAME}" --time-grain PT1M --start-time 2017-11-08T07:58:00Z --end-time 2017-11-08T13:30:00Z --metric-names compute_consumption_percent | egrep '(timeStamp|average)'

# Scale Azure PostgreSQL Compute - Switch to 100 ACU (1 vCPU), the output will then say capacity 100
az postgres server update --resource-group $MY_RG --name $PGSQL_NAME --compute-units 100

# Display Postgres Logs modified in the last 72 hours
az postgres server-logs list --resource-group $MY_RG --server $PGSQL_NAME

# Display Postgres Logs modified in the last 1 hour
az postgres server-logs list --resource-group $MY_RG --server $PGSQL_NAME --file-last-written 1

az postgres server-logs download --name 20170414-myserver4demo-postgres.log --resource-group $MY_RG --server $PGSQL_NAME

# Restore backup of Azure MySQL
# Postgres allows you to go back to any point in time in the last up to 35 days and restore this point in time to a new server.
az postgres server restore --resource-group $MY_RG --name mycliserver-restored --restore-point-in-time "2017-11-4 03:10" --source-server-name $PGSQL_NAME

# Remove database and resource group
az postgres server delete --name $PGSQL_NAME --resource-group $MY_RG --yes
az group delete --name $MY_RG --no-wait --yes
