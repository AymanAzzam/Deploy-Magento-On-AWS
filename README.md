# Deploy-Magento-On-AWS
An IaC using terraform to host Magento 2 application on AWS

## Prerequisites
1. AWS
    * Create **Access Key Id** and **Secret Access Key** for a user with the permissions
        * AmazonEC2FullAccess
        * AmazonRDSFullAccess
    * Create a key pair called **magento_key**
        * Put the pem file in the keys folder
2. Magento Application
    * Create a key pair
        * Put the the values in **scripts/var.yml**

## Steps
1. Add The created data from the prerequisites of aws in **99-variables.tf**
    * access_key 
    * secret_key
    * region (ex. us-east-1)
    * key_name (ex. magento_key)
    * magento_pem_file_path (ex. keys/magento_key.pem)
2. Add username and password for magento admin panel in **99-variables.tf**
    * magento_admin_user (ex. admin)
    * magento_admin_password (ex. admin123)
3. Add The created data from the prerequisites of magento application in **scripts/var.yml**
    * public_key
    * private_key
4. Add username and password for a new user on the magento server in **scripts/var.yml**
    * user (ex. magento)
    * password (ex. magento)
5. Run terraform command
```
terraform init
terraform plan -out="magento.tfplan"
terraform apply magento.tfplan
```