
# https://docs.oracle.com/en-us/iaas/Content/General/Concepts/identifiers.htm#tenancy_ocid
variable "tenancy_ocid" {
  default = ""
  description = "The OCID of the tenancy to be used"
  type = string
}

variable "region" {
  default = "us-ashburn-1"
  description = "Region where resources will be deployed"
  type = string
}

# https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm
variable "user_ocid" {
  default = ""
  description = "The OCID of the user to use for the OCI provider"
  type = string
}

# https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm
variable "fingerprint" {
  default = ""
  description = "The fingerprint of the public key used to interact with OCI"
}

# # https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm
variable "private_key_path" {
  default = ""
  description = "The path to the private API Signing Key."
}

variable "compartment_name" {
  default = "fvtt"
  description = "The name of the compartment to create all FVTT resources under"
}

variable "vcn_dns_label" {
  default = ""
  description = "A DNS label for the subnet, used in conjunction with the VNIC's hostname and VCN's DNS label"
}

# https://docs.oracle.com/en-us/iaas/images/
variable "instance_image" {
  default = "ocid1.image.oc1.iad.aaaaaaaah4rpzimrmnqfaxcm2xe3hdtegn4ukqje66rgouxakhvkaxer24oa" # Canonical-Ubuntu-22.04-2024.01.05-0
  description = "The OCID of the image to use for the instance, must be valid for your region."
  type = string
}

variable "boot_volume_size_in_gbs" {
  default = 50
  type = number
  description = "The size of the initial boot volume in GBs"
}

variable "duckdns_subdomain" {
  default = ""
  description = "The subdomain of the DuckDNS address to configure"
  type = string
}

variable "instance_state" {
  default = "RUNNING"
  description = "The state of the OCI instance, can be set to STOPPED to shutdown the instance."
}

# By default a weekly incremental backup on Mondays at 03:00 AM will be created and retained for 5 weeks
variable "enable_volume_backups" {
  default = true
  description = "Whether or not automatic weekly backups should be configured."
  type = bool
}

variable "volume_backup_policy_schedules_backup_type" {
  default = "INCREMENTAL"
  type = string
}

variable "volume_backup_policy_schedules_period" {
  default = "ONE_WEEK"
  type = string
}

variable "volume_backup_policy_schedules_retention_seconds" {
  default = 3024000 # 5 weeks
  type = number
}

variable "volume_backup_policy_schedules_day_of_week" {
  default = "MONDAY"
  type = string
}

variable "volume_backup_policy_schedules_hour_of_day" {
  default = 3
  type = number
}
