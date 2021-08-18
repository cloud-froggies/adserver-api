# Dev commands
virtualenv venv
source venv/bin/activate
pip3 freeze > requirements.txt         
pip install -r requirements.txt -t $PWD
deactivate
cd ..
zip -r advertisers-advertiser-id-get.zip advertisers-advertiser-id-get

# Deploy commands
terraform init
terraform plan -var-file="secret.tfvars" 
terraform apply -var-file="secret.tfvars"