variable "subscription_id"        { type= "string" default = "put the subscription id here" }
variable "client_id"              {}
variable "client_secret"          {}
variable "tenant_id"              { type= "string" default = "put the Azure tenant id here"}
variable "runner_resource_group"  { type= "string" default = "put the resource group" }

variable "GITLAB_ACCESS_TOKEN"    { type= "string" default = "gitlab access token" }
variable "resource_suffix"        { type= "string" default = "gitlab-runner" }
variable "hostname"               { type= "string" default = "gitlabrunnerVM" }

variable "sshkey_value"           { type= "string" description = "Please pass your public key if already generated,if not genrate by ssh-kgen(check man page) " }

variable "admin_user"             { type= "string" default = "user-gitlab" }

variable "location"               { type= "string" default = "eastus" }
variable "vmsize"                 { type= "string" default = "Standard_F8s_v2" }
variable "img_offer"              { type= "string" default = "Debian" }
variable "img_sku"                { type= "string" default = "9" }
variable "storage_type"           { type= "string" default = "Standard_LRS" }
variable "count"                  { type= "string" }
variable "env"                    { type= "string" default = " gitlabProd" }
variable "project"                { type= "string" default = "Gitlab_runner_project" }

variable "GITLAB_RUNNER_TOKEN"    { type= "string" default = "put gitlab runner token here"  }
variable "GITLAB_RUNNER_TAG"      { type= "string" default = "gitlab_runner_tag_" }
variable "GITLAB_RUNNER_EXECUTOR" { type= "string" default = "docker" }
variable "GITLAB_RUNNER_LOCKED"   { type= "string" default = "false" }
variable "GITLAB_URL"             { type= "string" default = "https://gitlab.com" }


variable "runner_vnet" { type= "string" default = "put the azre vnet here" }

variable "runner_nsg" { type= "string" default = "put azure network security group here" }

variable "runner_subnet" { type= "string" default = "put azure subnet here" }

