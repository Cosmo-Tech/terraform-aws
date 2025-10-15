![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
# Kubernetes cluster

## Requirements
* working AWS account (with admin access)
* Linux (Debian/Ubuntu) workstation with:
    * [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
    * [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
    * [jq](https://jqlang.org/)

## How to
* configure aws cli
    - ```aws configure```
    - If you are using  from AWS access portal
        - open "Access keys"
        - copy/paste *aws_access_key_id*, *aws_secret_access_key* and *aws_session_token*
    - ensure the connection is working
        - ```aws sts get-caller-identity```
* clone current repo
```git clone https://github.com/Cosmo-Tech/terraform-eks.git```
* open cloned repository
```cd terraform-eks```
* deploy
    * fill `terraform-cluster/terraform.tfvars` variables according to your needs
    * run pre-configured script
        * :information_source: comment/uncomment the *terraform apply* line at the end to get a plan without deploy anything
```_run-terraform.sh```
    * add kubectl context
```aws eks update-kubeconfig --region cluster_region --name cluster_name --alias cluster_name```

## Developpers
* modules
    * **terraform-state-storage**
        * standalone module intended to facilitate creation of a S3 storage (that will be used to store states of others modules)
        * state of this module itselft will not be saved, once created it should never be changed
        * manually create a S3 storage called "cosmotech-states" will have the same effect
    * **terraform-cluster**
        * *dns* = pre-configure DNS zones that will be required in next deployments
        * *cluster* = Kubernetes cluster
        * *cluster-nodes* = Kubernetes cluster nodes

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