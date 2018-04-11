KEY_VAULT_NAME=myvault
KEY_VAULT_RG=keyvault-rg

az group create --name $KEY_VAULT_RG --location southeastasia
az keyvault create --name $KEY_VAULT_NAME -g $KEY_VAULT_RG --sku standard --no-self-perms false
az keyvault list

# Add a name/password to vault
az keyvault secret set --vault-name $KEY_VAULT_NAME --name 'myapp' --value 'Pa$$w0rd'
# Display password stored in keyvault
az keyvault secret show --vault-name $KEY_VAULT_NAME --name myapp --query value
#Lists keys in Vault (not passwords)
az keyvault secret list --vault-name $KEY_VAULT_NAME

# Remove our vault
az keyvault delete --name $KEY_VAULT_NAME -g $KEY_VAULT_RG
az group delete --name $KEY_VAULT_RG --yes
