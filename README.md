![Static Badge](https://img.shields.io/badge/Cosmo%20Tech-%23FFB039?style=for-the-badge)
![Static Badge](https://img.shields.io/badge/AWS-%23ED7100?style=for-the-badge)

#  Kubernetes cluster

## Requirements
* working AWS account (with admin access)
* Linux (Debian/Ubuntu) workstation with:
    * [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
    * [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
    * [jq](https://jqlang.org/)

## How to
* configure aws cli
    ```
    aws configure
    ```
    * depending on type of authentication:
        * SSO user *(IAM Identity Center, AWS access portal)*
            * click on open "Access keys" beside the role you want to use
            * copy/paste `aws_access_key_id`, `aws_secret_access_key` and `aws_session_token` to the terminal command
        * basic user *(IAM)*
            * go to AWS > IAM
                * open concerned user
                * go to "Security credentials"
                    * create an "Access key"
                        * Use case = *Command line Interface (CLI)*
                        * check "I understand the above recommandations and want to proceed to create an access key"
                        * click on "Next"
                        * Decription tag value = `aws-cli`
                        * copy/paste `aws_access_key_id`, `aws_secret_access_key` to the terminal command
                        * Click on "Done"
    * ensure the connection is working
        ```
        aws sts get-caller-identity
        ```
* clone current repo
    ```
    git clone https://github.com/Cosmo-Tech/terraform-aws.git
    ```
* open cloned repository
    ```
    cd terraform-aws
    ```
* deploy
    * fill `terraform-cluster/terraform.tfvars` variables according to your needs
    * run pre-configured script
        > :information_source: comment/uncomment the `terraform apply` line at the end to get a plan without deploy anything
        ```
        ./_run-terraform.sh
        ```
    * to be able to connect to cluster with kubectl, your current AWS user must have the right. 
        > without good permissions, "system" node pool will appear as "Unknown"
        * go to AWS > EKS > deployed cluster > Access
        * create an assignment
            * IAM principal ARN = *your current user*
            * Type = Standard
            * click on "Next"
            * Policy name = `AmazonEKSClusterAdminPolicy`
            * Access scope = Cluster
            * click on "Add policy"
            * click on "Create"
    * add kube context (replace 'CLUSTERNAME' below with the real cluster name)
        ```
        sh -c 'aws eks update-kubeconfig --name $0 --alias $0' CLUSTERNAME
        ```
    * try a kubectl command to ensure the access is working
        ```
        kubectl get nodes
        ```

## Developpers
* modules
    * **terraform-state-storage**
        * standalone module intended to facilitate creation of a S3 storage (that will be used to store states of others modules)
        * state of this module itselft will not be saved, once created it should never be changed
        * manually create a S3 storage called `cosmotech-states` will have the same effect
    * **terraform-cluster**
        * *autostartstop* = automatically start & stop cluster on given timers
        * *cluster* = Kubernetes cluster
        * *dns* = pre-configure DNS zones that will be required in next deployments
        * *iam* = permission management
        * *network* = network management
        * *nodes* = Kubernetes cluster nodes
        * *rg* = organize resources over the cloud provider

* global_variables.tf files contains wide used variables and are symbolics links to the main variables.tf (to avoid code duplication).
    *copy/paste following block to ensure having global_variables.tf files in all child modules*
    ```
    for module in $(ls terraform-cluster/modules/); do
        cd terraform-cluster/modules/$module
        ln -sf ../../variables.tf global_variables.tf
        cd ../../../
    done
    ```

<br>
<br>
<br>

Made with :heart: by Cosmo Tech DevOps team