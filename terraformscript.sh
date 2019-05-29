#!/bin/bash


ACCOUNT_KEY="put the stoage account access key here"

echo "
------------------------------------------------------------------------------------------------------
This Script Will Help in Creation of Gitlab Runner and Destroying of All the Runner created at once  -
Use Destroy fucntion carefully,as it will delete of the Runners created by this script.              -
------------------------------------------------------------------------------------------------------
"
echo "
*******************************************
Select the below options:
*******************************************
select 1 -- CREATE gitlab runner

select 2 -- DESTROY ALL the runners created

"



read -p "Enter The Value From The Above Options (1 or 2):  " value

case $value in

1)
terraform init -input=false -backend-config=beconf.tfvars 2>/dev/null

az storage blob download -c terraform-state -f count -n count --account-name gitlabrunnerstate --account-key "$ACCOUNT_KEY"

count_var=`cat count`

terraform plan  -out=planVM.tfplan -var "count=$count_var" || exit

terraform apply -input=false -auto-approve planVM.tfplan ||exit

count_var=$(( count_var + 1))
echo "$count_var">count

az storage blob upload -c terraform-state -f count -n count --account-name gitlabrunnerstate --account-key "$ACCOUNT_KEY"

;;

2)

terraform init -input=false -backend-config=beconf.tfvars 2>/dev/null

terraform plan -destroy   -out=destroyplanVM.tfplan -var "count=0" || exit
echo "Terraform Destroy will apply in 30 sec,you can cancel if you want by pressing Control C"

sleep 30

terraform apply -input=false  destroyplanVM.tfplan

echo "1">count

az storage blob upload -c terraform-state -f count -n count --account-name gitlabrunnerstate --account-key "$ACCOUNT_KEY"

;;

*)
echo "Please seclect the correct Value"
;;
esac
