#!/bin/bash

LOCATION=southeastasia
MY_RG=daz-mysql-rg
MYSQL_NAME=mysqlserver4demo
DBADMIN=myadmin
DBPASSWORD=ssssssshhhhhhhss
SUBSCRIPTION_ID=1234567890

# https://docs.microsoft.com/en-us/azure/mysql/howto-server-parameters
# https://docs.microsoft.com/en-us/azure/mysql/overview

# Create Azure Resource Group
az group create --name $MY_RG --location $LOCATION --tags AppService=MySQL Environment=Development Owner=bill@microsoft.com

az mysql server create \
  --name $MYSQL_NAME \
  --resource-group $MY_RG \
  --location $LOCATION \
  --admin-user $DBADMIN \
  --admin-password $DBPASSWORD \
  --performance-tier Basic \
  --compute-units 50 \
  --tags Environment=Development Owner=bill@microsoft.com

# Check the value of *innodb_lock_wait_timeout*
az mysql server configuration show \
   --resource-group $MY_RG \
   --server-name $MYSQL_NAME \
   --name innodb_lock_wait_timeout

# Set value of *innodb_lock_wait_timeout*
az mysql server configuration set \
   --resource-group $MY_RG \
   --server-name $MYSQL_NAME \
   --name innodb_lock_wait_timeout \
   --value 120

# Configure Azure MySQL
az mysql server configuration show --name slow_query_log --resource-group $MY_RG --server $MYSQL_NAME
az mysql server configuration set --name slow_query_log --resource-group $MY_RG --server $MYSQL_NAME --value ON
az mysql server configuration set --name long_query_time --resource-group $MY_RG --server $MYSQL_NAME --value 10
az mysql server firewall-rule create --resource-group $MY_RG --server $MYSQL_NAME --name AllowAll --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
az mysql server update -g $MY_RG -n $MYSQL_NAME --ssl-enforcement Disabled

# Display MySQL database config
az mysql server configuration list --resource-group $MY_RG --server $MYSQL_NAME

mysql --host ${MYSQL_NAME}.mysql.database.azure.com --user ${DBADMIN}@${MYSQL_NAME} -p

CREATE DATABASE STAFF;
USE staff;
CREATE TABLE editorial (id INT, name VARCHAR(20), email VARCHAR(20));
SHOW tables;
INSERT INTO editorial (id,name,email) VALUES(01,"Olivia","olivia@company.com");
SELECT * FROM editorial;

# Show MySQL Host information, i.e. ACU
az mysql server show --resource-group $MY_RG --name $MYSQL_NAME

# Display CPU Metrics over a set timeframe
az monitor metrics list --resource "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${MY_RG}/providers/Microsoft.DBforMySQL/servers/${MYSQL_NAME}" --time-grain PT1M --start-time 2017-11-08T07:58:00Z --end-time 2017-11-08T13:30:00Z --metric-names compute_consumption_percent | egrep '(timeStamp|average)'

# Scale Azure MySQL Compute - Switch to 100 ACU (1 vCPU), the output will then say capacity 100
az mysql server update --resource-group $MY_RG --name $MYSQL_NAME --compute-units 100

# Display MySQL Logs modified in the last 72 hours
az mysql server-logs list --resource-group $MY_RG --server $MYSQL_NAME

# Display MySQL Logs modified in the last 1 hour
az mysql server-logs list --resource-group $MY_RG --server $MYSQL_NAME --file-last-written 1

az mysql server-logs download --name 20170414-myserver4demo-mysql.log --resource-group $MY_RG --server $MYSQL_NAME

# Restore backup of Azure MySQL
# MySQL allows you to go back to any point in time in the last up to 35 days and restore this point in time to a new server.
az mysql server restore --resource-group $MY_RG --name mycliserver-restored --restore-point-in-time "2017-11-4 03:10" --source-server-name $MYSQL_NAME

# Remove database and resource group
az mysql server delete --name $MYSQL_NAME --resource-group $MY_RG --yes
az group delete --name $MY_RG --no-wait --yes
