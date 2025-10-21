#!/bin/sh

# Script to run terraform modules 
# Usage :
# - ./script.sh


# Stop script if missing dependency
required_commands="terraform aws jq"
for command in $required_commands; do
	if [ -z "$(command -v $command)" ]; then
		echo "error: required command not found: \e[91m$command\e[97m"
        exit
	fi
done


# Get value of a variable declared in a given file from this pattern: variable = value
# Usage: get_var_value <file> <variable>
get_var_value() {
    local file=$1
    local variable=$2

    cat $file | grep '=' | grep -w $variable | sed 's|.*"\(.*\)".*|\1|' | head -n 1
}
cluster_name="$(get_var_value terraform-cluster/terraform.tfvars cluster_name)"
cluster_stage="$(get_var_value terraform-cluster/terraform.tfvars cluster_stage)"
cluster_region="$(get_var_value terraform-cluster/terraform.tfvars cluster_region)"

state_storage_name="$(get_var_value terraform-state-storage/main.tf bucket)"

# Ensure a storage service exist to store the states and ask to create it if doesn't exist
# Trick is to create the storage service with the var cluster_region if it doesn't exist yet
if [ -z "$(aws s3 ls --bucket-name $state_storage_name)" ]; then

    # Clear old data
    rm -rf terraform-state-storage/.terraform*
    rm -rf terraform-state-storage/terraform.tfstate*

    echo "error: storage to host states not found: \e[91m$state_storage_name\e[0m"
    echo "you can either:"
    echo "  - manually create a S3 storage with this name: $state_storage_name"
    echo "  - run terraform-state-storage that will create it (copy/paste following commands to do so)"
    echo "      terraform -chdir=terraform-state-storage init"
    echo "      terraform -chdir=terraform-state-storage plan -out .terraform.plan -var 'region=$cluster_region'"
    echo "      terraform -chdir=terraform-state-storage apply .terraform.plan"
    exit
else
    echo "getting state storage region..."
    state_storage_region="$(aws --output json s3api get-bucket-location --bucket $state_storage_name | jq -r '.LocationConstraint')"
    if [ "$(echo $state_storage_region)" != "" ]; then
        echo "found $state_storage_name in $state_storage_region"
    else
        echo "error: $state_storage_name not found in $state_storage_region"
        exit
    fi
fi

# Clear old data
rm -rf terraform-cluster/.terraform*

# Deploy
terraform -chdir=terraform-cluster init -upgrade -backend-config="bucket=$state_storage_name" -backend-config="region=$state_storage_region" -backend-config="key=tfstate-eks-$cluster_stage-$cluster_name"
terraform -chdir=terraform-cluster plan -out .terraform.plan

while read -p "Apply? [write 'yes please' to confirm] (CTRL+C to exit): " apply_confirmation
do
    if [ "$(echo $apply_confirmation)" = "yes please" ]; then
        terraform -chdir=terraform-cluster apply .terraform.plan
        break
    fi
done

exit