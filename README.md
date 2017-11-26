# azure-cli2-commands

<pre>
15th July 2017 - az 2.10 is the latest

# Installing az
curl -L https://aka.ms/InstallAzureCli | bash

$ azure login
$ azure account set "<SUBSCRIPTION NAME OR ID>"
$ azure config mode arm

# Or run az from a container (did'nt work when last tested due to Python dependency's)
docker run -v ${HOME}:/root -it azuresdk/azure-cli-python:latest

# Display subscription ID and Tenant ID
$ az account show --query "{subscriptionId:id, tenantId:tenantId}"

$ az group list | grep '"name":'
    "name": "my-rg",

$ az vm list --show-details -d --output jsonc | egrep '(powerState|offer|sku|vmName|resourceGroupName|Ips)'
    "powerState": "VM running",
    "privateIps": "10.200.200.5",
    "publicIps": "",
          "resourceGroupName": "MYRG",
          "vmName": "k8s-master-6F3AE52A-0",
        "offer": "UbuntuServer",
        "sku": "16.04.0-LTS",

$ az vm list --show-details -d --output table
Name                   ResourceGroup    PowerState      Fqdns                                        Location       PublicIps
---------------------  ---------------  --------------  -------------------------------------------  -------------  -------------
WINSERVER2016          2016SERVER-RG    VM deallocated  win2016.southeastasia.cloudapp.azure.com  southeastasia
k8s-agent-6F3AE52A-0   DAZK8SRG         VM running                                                   southeastasia
k8s-agent-6F3AE52A-1   DAZK8SRG         VM running                                                   southeastasia
k8s-agent-6F3AE52A-2   DAZK8SRG         VM running                                                   southeastasia
k8s-master-6F3AE52A-0  DAZK8SRG         VM running                                                   southeastasia
RHEL73                 RHEL73_RG        VM running                                                   southeastasia  12.200.200.13

$ az vm list --query "[?provisioningState=='Succeeded'].{ name: name, os: storageProfile.osDisk.osType }"

$ az vm restart --resource-group myrg --name "k8s-agent-6F3AE52A-2"
{
  "endTime": "2017-07-06T06:00:24.997282+00:00",
  "error": null,
  "name": "37ebeef3-d174-4c81-b566-8d902f2d1af8",
  "startTime": "2017-07-06T06:00:24.872255+00:00",
  "status": "Succeeded"
}

# Display all RHEL images in southeastasia region
$ az vm image list -o table --location southeastasia --offer RHEL --all

$ az vm image list -o table --location southeastasia --all
You are viewing an offline list of images, use --all to retrieve an up-to-date list
Offer          Publisher               Sku                 Urn                                                             UrnAlias             Version
-------------  ----------------------  ------------------  --------------------------------------------------------------  -------------------  ---------
WindowsServer  MicrosoftWindowsServer  2016-Datacenter     MicrosoftWindowsServer:WindowsServer:2016-Datacenter:latest     Win2016Datacenter    latest
WindowsServer  MicrosoftWindowsServer  2012-R2-Datacenter  MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:latest  Win2012R2Datacenter  latest
WindowsServer  MicrosoftWindowsServer  2008-R2-SP1         MicrosoftWindowsServer:WindowsServer:2008-R2-SP1:latest         Win2008R2SP1         latest
WindowsServer  MicrosoftWindowsServer  2012-Datacenter     MicrosoftWindowsServer:WindowsServer:2012-Datacenter:latest     Win2012Datacenter    latest
UbuntuServer   Canonical               16.04-LTS           Canonical:UbuntuServer:16.04-LTS:latest                         UbuntuLTS            latest
CentOS         OpenLogic               7.3                 OpenLogic:CentOS:7.3:latest                                     CentOS               latest
openSUSE-Leap  SUSE                    42.2                SUSE:openSUSE-Leap:42.2:latest                                  openSUSE-Leap        latest
RHEL           RedHat                  7.3                 RedHat:RHEL:7.3:latest                                          RHEL                 latest
SLES           SUSE                    12-SP2              SUSE:SLES:12-SP2:latest                                         SLES                 latest
Debian         credativ                8                   credativ:Debian:8:latest                                        Debian               latest
CoreOS         CoreOS                  Stable              CoreOS:CoreOS:Stable:latest                                     CoreOS               latest

az group create --name ubuntu-rg --location southeastasia

az vm create \
    --resource-group ubuntu-rg \
    --name ubuntuVM1 \
    --location southeastasia \
    --image UbuntuLTS \
    --ssh-key-value ~/.ssh/id_rsa.pub \
    --admin-username azureuser

az vm open-port --port 8000 --resource-group ubuntu-rg --name ubuntuVM1

Create a managed disk, using Azure CLI 2.0 in this example:
 az disk create --resource-group rg1 --name fedora26managed --source https://username.blob.core.windows.net/container1/fedora26.vhd

Verify its really there:
 az disk list -g resourcegroup1 --output=table

Create your vm with 5GB (or more) additional data disk:
 az vm create --resource-group rg1 --location westeurope --name fedora26 --os-type linux \
 --admin-username username --ssh-key-value ~/.ssh/id_rsa.pub --attach-os-disk fedora26managed \
 --size Standard_DS1 --data-disk-sizes-gb 5

Your metadata is stored outside of the VM and includes the external IP address, amongst other data.
curl -H Metadata:true http://169.254.169.254/metadata/instance?api-version=2017-03-01

</pre>

https://github.com/Azure/azure-cli<br>
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-manage<br>
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-vm<br>
