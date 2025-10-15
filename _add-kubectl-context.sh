#!/bin/sh

# Script to quickly add an EKS cluster context for kubectl
# Usage :
# - ./script.sh
# - ./script.sh <cluster_name>


# Stop script if missing dependency
required_commands="aws jq"
for command in $required_commands; do
	if [ -z "$(command -v $command)" ]; then
		echo "error: required command not found: \e[91m$command\e[97m"
        exit
	fi
done


# Read cluster name from args or ask for it
if [ -z $1 ]; then
    read -p "enter cluster name: " cluster_name
else
    cluster_name=$1
fi


# Configure cluster context
if [ -z "$(aws --output json eks list-clusters | jq -r '.clusters[]' | grep -w $cluster_name)" ]; then
    echo "error: cluster not found: \e[91m$cluster_name\e[0m"
else
    cluster_region="$(aws --output json eks describe-cluster --name $cluster_name | jq -r '.cluster.arn' | sed 's|arn:aws:eks:\(.*\):.*:.*|\1|')"

    echo "setting context..."
    aws eks update-kubeconfig --region $cluster_region --name $cluster_name --alias $cluster_name 
fi


exit