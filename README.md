<span style="color: #FFB039; font-weight: bold;">AWS</span>

# Kubernetes cluster

### Requirements
* working AWS account
* Linux (Debian/Ubuntu) workstation with:
    * [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) ready to use (with AWS account credentials configured)
    * [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) ready to use

### How to
* configure aws cli
* clone current repo
```git clone https://github.com/Cosmo-Tech/terraform-eks.git```
* open cloned repository
```cd terraform-eks```
* deploy
    * set default AWS region in providers.tf
    * if first cluster:
```./_create_state_storage-terraform.sh```
    * fill `terraform-cluster/terraform.tfvars` variables according to your needs
    * run pre-configured script
```_run-terraform.sh```


### Good to know
#### Modules variables.tf files are symbolics links to main variables.tf to avoid code duplication.
*copy/paste following block to ensure having global_variables.tf files in all child modules*
```
for module in $(ls terraform-cluster/modules/); do
    cd terraform-cluster/modules/$module
    ln -sf ../../variables.tf global_variables.tf
    cd ../../../
done
```

#### Deployments items & wokflow
* modules
    * **terraform-state-storage**
        * standalone module intended to facilitate creation of a S3 storage (that will be used to store states of others modules)
        * state of this module itselft will not be saved, once created it should never be changed
        * manually create a S3 storage call "cosmotech-states" will have the same effect
    * **terraform-cluster**
        * *dns* = pre-configure DNS zones that will be required in next deployments
        * *cluster* = Kubernetes cluster
        * *cluster-nodes* = Kubernetes cluster nodes

* workflow
    * 1> deploy state storage solution
    * 2> deploy Cosmo Tech platform
        * 2.1> deploy dns
        * 2.2> deploy cluster
        * 2.3> deploy cluster-nodes

<br>
<br>
<br>

Made with :heart: by Cosmo Tech DevOps team