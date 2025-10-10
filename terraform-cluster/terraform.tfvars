cluster_name   = "devops5"
cluster_stage  = "dev"
cluster_region = "eu-west-3"

# You can add or remove tags according to your needs (the following list is just an example)
additional_tags = {
  cost_center = "n/a"
  vendor      = "cosmotech"
  customer    = "cosmotech"
}








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
