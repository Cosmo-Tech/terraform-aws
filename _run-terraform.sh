#!/bin/sh

# set -x

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

    cat $file | grep -w $variable | sed 's|.*"\(.*\)".*|\1|' | head -n 1
}
cluster_name="$(get_var_value terraform-cluster/terraform.tfvars cluster_name)"
cluster_stage="$(get_var_value terraform-cluster/terraform.tfvars cluster_stage)"
cluster_region="$(get_var_value terraform-cluster/terraform.tfvars cluster_region)"

state_storage_name="$(get_var_value terraform-state-storage/main.tf bucket)"

# Ensure a storage service exist to store the states and ask to create it if doesn't exist
# Trick is to create the storage service with the var cluster_region if it doesn't exist yet
if [ -z "$(aws s3 ls --bucket-name-prefix $state_storage_name)" ]; then
    echo "error: storage to host states not found: \e[91m$state_storage_name\e[0m"
    echo "you can either:"
    echo "  - manually create a S3 storage with this name: $state_storage_name"
    echo "  - run terraform-state-storage that will create it (copy/paste following commands to do so)"
    echo "      terraform -chdir=terraform-state-storage init"
    echo "      terraform -chdir=terraform-state-storage plan -out .terraform.plan -var 'region=$cluster_region'"
    echo "      terraform -chdir=terraform-state-storage apply .terraform.plan"
    exit
else
    state_storage_region="$(aws s3api head-bucket --bucket $state_storage_name | jq -r '.BucketRegion')"
fi

# Clear old data
rm -rf terraform-cluster/.terraform*

# Deploy
terraform -chdir=terraform-cluster init -upgrade -backend-config="bucket=$state_storage_name" -backend-config="key=tfstate-eks-$cluster_stage-$cluster_name" -backend-config="region=$state_storage_region"
terraform -chdir=terraform-cluster plan -out .terraform.plan
terraform -chdir=terraform-cluster apply .terraform.plan


exit