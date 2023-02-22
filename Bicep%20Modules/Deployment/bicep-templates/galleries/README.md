No module created as there is only likely to be one gallery used by all environments
Same for prefixes and naming standards - not required for a 1 off

Service Principal needs to a member of

SG-SharedImageGalleryAdmins



Disk ID is hard coded
```json
"diskId": "/subscriptions/8a1389fe-c983-4fc3-99ad-b7413829bcd3/resourceGroups/RG-PROD-AE-COMPUTE/providers/Microsoft.Compute/disks/vmprodaeva01-disk-os"
```

To create the image

```bash
#Install Azure Cli
sudo apt-get update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Download Image and unzip - Unzipping required 130GB of space
curl https://sppcbu-va-images.s3.amazonaws.com/va-azure-latest.zip --output va-azure-latest.zip
sudo apt install unzip
unzip va-azure-latest.zip 


#Set variables
storage_account=saprodaefile01
storage_group=rg-prod-ae-storage
vhd_url="https://saprodaefile01.blob.core.windows.net/sailpoint/sailpoint-va.vhd"
compute_group="rg-prod-ae-compute"
va_appliance_disk=vmprodaeva01-disk-os
vhd="sailpoint-va.vhd"
container="sailpoint"

# login to azure
az login
#check network firewall on storage account
connection_string=`az storage account show-connection-string --name $storage_account --query '[connectionString]' --output tsv`
#Upload image and create VHD
az storage blob upload --container-name $container --file $vhd --name $vhd --connection-string $connection_string --overwrite
az disk create --resource-group $compute_group --name $va_appliance_disk --source https://saprodaefile01.blob.core.windows.net/sailpoint/sailpoint-va.vhd


#Get subnet for sailpoint servers
subnetid=$(az network vnet subnet show --resource-group "rg-prod-ae-network"  --name "sn-prod-ae-sailpoint-01" --vnet-name "vn-prod-ae-hub-01" --query id -o tsv)

# Create nic
az network nic create -g "rg-prod-ae-compute" --subnet $subnetid -n "vmprodaeva01-nic-01"
nic=$(az network nic show --resource-group "rg-prod-ae-compute" -n "vmprodaeva01-nic-01" --query id --output tsv) 

# Create VM
az vm create --resource-group rg-prod-ae-compute --location AustraliaEast --name vmprodaeva01 --os-type linux --attach-os-disk "vmprodaeva01-disk-os" --size "Standard_B2ms" --nics $nic

``