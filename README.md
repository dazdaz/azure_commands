# azure-cli2-commands

<pre>
13th April 2018 - az 2.0.31 is the latest

# Installing az
curl -L https://aka.ms/InstallAzureCli | bash

$ azure login
$ azure account set "<SUBSCRIPTION NAME OR ID>"
$ azure config mode arm

# View Azure VM Types available in SouthEastAsia regin (Singapore)
az vm list-sizes --location southeastasia | grep _v3

# View publishers of SKU's
az vm image list-publishers --location southeastasia --output table

# View RedHat offers (SKU's) - RHEL, rhel-byol, RHEL-SAP-HANA, 
az vm image list-offers --publisher RedHat --location southeastasia

# List SKU's - 7.3, 7.2, 7.1
az vm image list-skus --offer RHEL --publisher RedHat --location southeastasia --output table

# View all RHEL SKU's
az vm image list --location southeastasia --offer RHEL --publisher RedHat --sku 7.3 --all --output table

# Display image info on RHEL 7.3 - The image name is : 7.3.2017090723
az vm image show --location southeastasia --publisher RedHat --offer RHEL --sku 7.3 --version 7.3.2017090723

# View Ubuntu Image Specs
az vm image show --location westus --publisher Canonical --offer UbuntuServer --sku 16.04-LTS --version 16.04.201801260

# View Urn and UrnAlias of all images in a region - may timeout
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

# Build out VM
az group create --name ubuntu-rg --location southeastasia
az vm create \
    --resource-group ubuntu-rg \
    --name ubuntuVM1 \
    --location southeastasia \
    --image UbuntuLTS \
    --ssh-key-value ~/.ssh/id_rsa.pub \
    --admin-username azureuser

az vm create --resource-group rg1 --location westeurope --name fedora26 --os-type linux \
 --admin-username username --ssh-key-value ~/.ssh/id_rsa.pub --attach-os-disk fedora26managed \
 --size Standard_DS1 --data-disk-sizes-gb 5

# Create a managed disk, using Azure CLI 2.0 in this example:
az disk create --resource-group rg1 --name fedora26managed --source https://username.blob.core.windows.net/container1/fedora26.vhd

# Verify its really there:
az disk list -g resourcegroup1 --output=table

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

# Your metadata is stored outside of the VM and includes the external IP address, amongst other data.
curl -H Metadata:true http://169.254.169.254/metadata/instance?api-version=2017-03-01

# View your Azure VM Type
curl -H Metadata:true http://169.254.169.254/metadata/instance?api-version=2017-12-01 2>/dev/null | jq -c '.[] | {vmSize}'
{"vmSize":"Standard_D2s_v3"}

# To update the failed network interface:
az network nic update -g RG-NAME -n NIC-NAME

# Display Azure VM Types (SKU's) within a region
az vm list-skus --location southeastasia --query '[].name' -o table

# List the name of the resource group in table output format:
az group list --query '[].name' -o table

# Deploying a soution from Azure Marketplace using Azure CLI
https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/virtual-machines/linux/cli-ps-findimage.md

# Remove the Service Principal
az ad sp delete --id "Fabmedical-sp"

# Execute commands as root from outside of the VM.
# When the sudoers file has become corrupt and you don't have a root password you can easily fix this.
az vm extension set -g ubuntu1710-rg --vm-name ubuntu1710 -n customScript --publisher Microsoft.Azure.Extensions \
--settings "{\"commandToExecute\": \"chmod o+w /etc/sudoers\"}" --version 2.0

Control-c after 30 seconds

$ ls -l /etc/sudoers
-r--r---w- 1 root root 755 Jun 13  2017 /etc/sudoers
</pre>

## Disk Management
### Expanding an Azure data disk - Requires you to power-off the VM
* https://docs.microsoft.com/en-us/azure/virtual-machines/linux/expand-disks
```
# Display managed disks within a resource group, size is in GiB
az disk list -g rhel75-rg --output table
Name                                              ResourceGroup    Location       Zones    Sku            SizeGb  ProvisioningState    OsType
------------------------------------------------  ---------------  -------------  -------  -----------  --------  -------------------  --------
rhel75_disk2_7c2ffb9dd9f94fc68ac0fc976d58436f     rhel75-rg        southeastasia           Premium_LRS         5  Succeeded
rhel75_disk3_09713040473f426c952aae77c67fe95c     rhel75-rg        southeastasia           Premium_LRS         5  Succeeded
rhel75_OsDisk_1_43958238a75444199b25b7d8336bb939  rhel75-rg        southeastasia           Premium_LRS        32  Succeeded            Linux

# List the VM Type resize options available
az vm list-vm-resize-options --name ubuntu1710 --resource-group ubuntu1710-rg
# Deallocate disk from VM
az vm deallocate --resource-group myResourceGroupDisk --name myVM
# Resize a disk - Enter the new size
az disk update --name myDataDisk --resource-group myResourceGroupDisk --size-gb 1023
# Start VM
az vm start --resource-group myResourceGroup --name myVM

# Un-mount disk, if auto-mounted when VM starts
sudo parted /dev/sdc
 (parted) resizepart
 Partition number? 1
 End?  [107GB]? 215GB
sudo e2fsck -f /dev/sdc1
sudo resize2fs /dev/sdc1
sudo mount /dev/sdc1 /datadrive
df -h /datadrive1

# Test random R/W to see IOPS - uses entire disk
df -h /datadrive3
sudo fio -filename=/datadrive3/test -iodepth=8 -ioengine=libaio -direct=1 -rw=randwrite -bs=4k \
-numjobs=1 -runtime=30 -group_reporting -name=test-randwrite -size 479G
```

### Re-moving a Disk
```
az disk list --resource-group ubunth1710-rg--query '[].name' -o table
az vm disk detach -g ubuntu1710-rg --vm-name ubuntu1710 --name myDataDisk1
```

## Storage troubleshooting
* Maximum throughput and IOPS are based on the VM limits, not on the disk limits.
* Cross reference throughput required as indicated in the Premium Disk with the Azure VM Type.
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/premium-storage#premium-storage-scalability-and-performance-targets
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes-general

## Links
https://github.com/Azure/azure-cli<br>
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-manage<br>
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-vm<br>
