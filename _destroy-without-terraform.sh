#!/bin/sh

# Script to quickly delete all resources from an AWS resource group
# Usage :
# - ./script.sh
# - ./script.sh <rg_name>


# Stop script if missing dependency
required_commands="aws jq"
for command in $required_commands; do
	if [ -z "$(command -v $command)" ]; then
		echo "error: required command not found: \e[91m$command\e[97m"
        exit
	fi
done


# Read name from args or ask for it
if [ -z $1 ]; then
    read -p "enter resource group name: " rg_name
else
    rg_name=$1
fi


file_tmp="/tmp/aws_rg_$rg_name"
file_tmp_interfaces="$file_tmp-interfaces"
file_tmp_routetables="$file_tmp-routetables"
# Get list of resources from a resource group and store it to a file
# Usage: gt_rg_resources
gt_rg_resources() {
    aws resource-groups list-group-resources --group-name $rg_name | jq -r '.ResourceIdentifiers[].ResourceArn' > $file_tmp
}

# Simple timer to wait for a resource to be destroyed
# Usage: wait_resource_destruction <resource>
wait_resource_destruction() {
    local resource=$1

    while [ "$(cat $file_tmp | grep -w $resource)" != "" ]; do
        gt_rg_resources
        echo "waiting for destruction of $resource"
        sleep 10
    done
}


# Get the list a first time
gt_rg_resources


if [ -z "$(cat $file_tmp)" ]; then
    echo "error: nothing found"
else
    echo "$rg_name contains:"
    cat $file_tmp

    # Ask for confirmation
    read -p "enter resource group name to confirm destruction of all its resouces ('$rg_name'): " confirmation
    if [ "$(echo $confirmation)" = "$rg_name" ]; then
        echo "deleting resources from $rg_name..."

        # Try until everything has been deleted (because some resources have dependencies and might not be deleted the first time)
        while [ "$(cat $file_tmp)" != "" ]; do

            # Refresh resource list file
            gt_rg_resources

            while read resource; do

                resource_type="$(echo $resource | cut -d ':' -f 6 | cut -d '/' -f 1)"
                resource_id="$(echo $resource | cut -d ':' -f 6 | cut -d '/' -f 2)"

                cluster_name="$(echo $resource | cut -d '/' -f 2)"


                # echo "resource           $resource"
                # echo "resource_type      $resource_type"
                # echo "resource_id        $resource_id"

                if [ "$(echo $resource_type)" = "natgateway" ]; then
                    echo "deleting nat gateway      $resource_id"
                    aws ec2 delete-nat-gateway --nat-gateway-id $resource_id > /dev/null

                    wait_resource_destruction $resource
                fi

                if [ "$(echo $resource_type)" = "elastic-ip" ]; then
                    echo "deleting elastic ip       $resource_id"
                    aws ec2 release-address --allocation-id $resource_id > /dev/null

                    wait_resource_destruction $resource
                fi

                if [ "$(echo $resource_type)" = "nodegroup" ]; then
                    echo "deleting nodegroup        $resource_id"
                    # nodegroup_name="$(echo $resource | cut -d '/' -f 3)"
                    aws eks delete-nodegroup --cluster-name $cluster_name --nodegroup-name $resource_id > /dev/null

                    wait_resource_destruction $resource
                fi

                if [ "$(echo $resource_type)" = "cluster" ]; then
                    echo "deleting cluster          $cluster_name"
                    aws eks delete-cluster --name $cluster_name > /dev/null

                    wait_resource_destruction $resource
                    # while [ -z "$(cat $file_tmp | grep $resource)" ]; do
                    #     gt_rg_resources
                    #     echo "waiting for destruction of $resource"
                    #     sleep 10
                    # done
                fi

                if [ "$(echo $resource_type)" = "subnet" ]; then
                    echo "deleting subnet           $resource_id"
                    aws ec2 delete-subnet --subnet-id $resource_id > /dev/null

                    # wait_resource_destruction $resource
                fi

                if [ "$(echo $resource_type)" = "internet-gateway" ]; then
                    echo "deleting internet gateway..."
                    vpc_id="$(cat $file_tmp | cut -d '/' -f 2 | grep vpc)"

                    aws ec2 detach-internet-gateway --internet-gateway-id $resource_id --vpc-id $vpc_id > /dev/null
                    aws ec2 delete-internet-gateway --internet-gateway-id $resource_id > /dev/null

                    # wait_resource_destruction $resource
                fi

                if [ "$(echo $resource_type)" = "vpc" ]; then

                    # aws ec2 describe-network-interfaces > $file_tmp_interfaces
                    # interface_attachments="$(cat $file_tmp_interfaces | jq -r '.NetworkInterfaces[] | select(.VpcId=="'$resource_id'").Attachment.AttachmentId')"
                    # for attachment_id in $interface_attachments; do
                    #     interface_id="$(cat $file_tmp_interfaces | jq -r '.NetworkInterfaces[] | select(.Attachment.AttachmentId="'$attachment_id'").NetworkInterfaceId')"

                    #     # echo "attachment_id         $attachment_id"
                    #     # echo "interface_id          $interface_id"
                    #     aws ec2 detach-network-interface --attachment-id $attachment_id
                    #     aws ec2 delete-network-interface --network-interface-id $interface_id
                    # done

                    aws ec2 describe-route-tables > $file_tmp_routetables
                    routetable_ids="$(cat $file_tmp_routetables | jq -r '.RouteTables[] | select(.VpcId=="'$resource_id'").RouteTableId')"

                    for routetable_id in $routetable_ids; do
                        echo "deleting route table      $resource_id"
                        aws ec2 delete-route-table --route-table-id $routetable_id > /dev/null
                    done

                    echo "deleting vpc              $resource_id"
                    aws ec2 delete-vpc --vpc-id $resource_id > /dev/null

                    # wait_resource_destruction $resource
                fi

                if [ "$(echo $resource_type)" = "launch-template" ]; then
                    echo "deleting launch template  $resource_id"
                    aws ec2 delete-launch-template --launch-template-id $resource_id > /dev/null
 
                    wait_resource_destruction $resource
                fi

                if [ "$(echo $resource_type)" = "resource-groups" ]; then
                    echo "deleting resource group   $resource_id"
                    aws resource-groups delete-group --group-name $rg_name > /dev/null
 
                    wait_resource_destruction $resource
                fi



                # To add: IAM roles
            done < $file_tmp
        done

    else
        echo "nothing will be destroyed, aborting..."
    fi
fi

rm -f $file_tmp
rm -f $file_tmp*

exit