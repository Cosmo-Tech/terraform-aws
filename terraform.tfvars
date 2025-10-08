cluster_name = "devops-test-3"
cluster_stage = "test"
cluster_region = "eu-west-1"















# eks_cluster_iam_role = <AWS service to create with terraform>               -> should not be a variable

# eks_configuration_option = custom                   -> should not be a variable
# eks_version = latest                                -> should not be a variable
# eks_upgrade_policy = auto                           -> should not be a variable
# eks_region = eu-west-3 

# eks_auto_mode = false                               -> should not be a variable
# eks_cluster_access = eks_api                        -> should not be a variable
# eks_allow_cluster_administrator_access = true       -> should not be a variable

# eks_deletion_protection = true                      -> should not be a variable


# # Network
# eks_network_name = default ?                        -> should not be a variable
# eks_network_family = ipv4                           -> should not be a variable
# eks_network_block = 10.0.0.0/16                     -> Must be automatic from what already exists and not a variable
# eks_cluster_endpoint_access = public & private      -> should not be a variable



# # Monitoring
# eks_send_logs = disable (will disable multiple things)  -> should not be a variable
# eks_marketplace_addons = none                           -> should not be a variable


# eks_resource_group = based on tag, so need to create tag first

# # Launch template
# eks_launch_template = ubuntu + cpu/ram/disk             -> should not be a variable + should be created with the cluster once, and then reused if already exists on the account




# # Azure -> AWS equivalents
# # aks                   -> eks
# # app registration      ->
# # network?              ->
# # resource group        -> 


# # to install on it
# # - ingress
# # - vault
# # - keycloak
# # - velero
# # - grafana

# -------------------------------------------------------------------------------
# db, monitoring, highmemory, basic, services, highcpu
# - Max pods per node         = 110
# - Public IPs per node       = Disabled
# - Autoscaling               = Enabled => TO DISCUSS
# - Azure Spot Instance       = Disabled
# - Maximum price             = N/A
# - Scale eviction policy     = N/A
# - Node image version        = AKSUbuntu-2204gen2containerd-202508.20.1
# - Proximity placement group = N/A
# - Mode                      = User
# - Maximum surge             = 10%
# - Node drain timeout        = 30
# - Skip undrainable nodes    = Disabled
# - OS disk size              = 128 GB
# - OS disk type              = Managed
# - Virtual network           = CosmoTechcosmotechaks-devopsDevVNet
# - Subnet                    = default
# - Taints
#     vendor=cosmotech.com:NoSchedule
# - Labels
#     cosmotech.com/tiers : db
#     cosmotech.com/tiers : monitoring
#     cosmotech.com/tiers : highmemory
#     cosmotech.com/tiers : basic
#     cosmotech.com/tiers : services
#     cosmotech.com/tiers : highcpu

# -------------------------------------------------------------------------------
# system
# - Max pods per node         = 110
# - Public IPs per node       = Disabled
# - Autoscaling               = Enabled => TO DISCUSS
# - Azure Spot Instance       = Disabled
# - Maximum price             = N/A
# - Scale eviction policy     = N/A
# - Node image version        = AKSUbuntu-2204gen2containerd-202508.20.1
# - Proximity placement group = N/A
# - Mode                      = System
# - Maximum surge             = 10%
# - Node drain timeout        = 30
# - Skip undrainable nodes    = Disabled
# - OS disk size              = 128 GB
# - OS disk type              = Managed
# - Virtual network           = CosmoTechcosmotechaks-devopsDevVNet
# - Subnet                    = default

# -------------------------------------------------------------------------------
# db
# - Node size: Standard_D4ads_v5
# - cpu : 4
# - ram : 16 Go

# monitoring
# - Node size: Standard_D2ads_v5
# - cpu : 2
# - ram : 8 Go

# highmemory
# - Node size: Standard_E16ads_v5
# - cpu : 16
# - ram : 128 Go

# basic
# - Node size: Standard_F4s_v2
# - cpu : 4
# - ram : 8 Go

# services
# - Node size: Standard_B4ms
# - cpu : 4
# - ram : 16 Go

# highcpu
# - Node size: Standard_F72s_v2
# - cpu : 72
# - ram : 144 Go

# system
# - Node size: Standard_DS2_v2
# - cpu : 2
# - ram : 7 Go
