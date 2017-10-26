#!/bin/bash

cd vpc1
terraform init
terraform apply

cd ../webapp1
terraform init
terraform apply

echo "Tapper une touche pour swither"
read -n 1

cd ../vpc2
terraform init
terraform apply

cd ../webapp2
terraform init
terraform apply

echo "pause le temps que la machine soit OK"
sleep 15

cd ../webapp1
terraform destroy

cd ../vpc1
terraform destroy

