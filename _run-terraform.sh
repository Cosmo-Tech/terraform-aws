#!/bin/sh

# set -x



# Stop script if missing dependency
required_commands="terraform aws fffffff"
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


if [ -z "$(aws s3 ls)" ]; then
    echo "error: storage to host states not found: \e[91m$state_storage_name\e[97m"
    echo "you can either:"
    echo "  - manually create a storage service with this name: $state_storage_name"
    echo "  - run terraform-state-storage that will create it (copy/paste following commands to do so)"
    echo "      cd terraform-state-storage"
    echo "      terraform init"
    echo "      terraform plan -out .terraform.plan"
    echo "      terraform apply .terraform.plan"
    echo "      cd ../"
    exit
fi

# terraform init \
#     -backend-config="bucket=cosmotech-states" \
#     -backend-config="key=tfstate-$cluster_stage-$cluster_name" \
#     -backend-config="region=${cluster_region}" \
#     -upgrade \
#     -migrate-state


# terraform plan -out .terraform.plan
# # terraform apply .terraform.plan
# # terraform apply .terraform.plan \
# #     -target=module.cluster \
# #     -state-out=.terraform.state.cluster


exit