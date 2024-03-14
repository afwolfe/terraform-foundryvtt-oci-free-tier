resource "oci_core_volume_backup_policy" "fvtt-backup-policy" {
    count = var.enable_volume_backups ? 1 : 0
    compartment_id = oci_identity_compartment.fvtt-compartment.id

    display_name = "FVTT Backup"
    schedules {
        backup_type = var.volume_backup_policy_schedules_backup_type
        period = var.volume_backup_policy_schedules_period
        retention_seconds = var.volume_backup_policy_schedules_retention_seconds

        day_of_week = var.volume_backup_policy_schedules_day_of_week
        hour_of_day = var.volume_backup_policy_schedules_hour_of_day
        time_zone = "REGIONAL_DATA_CENTER_TIME"
    }
}

resource "oci_core_volume_backup_policy_assignment" "fvtt-volume-backup-policy-assignment" {
    count = var.enable_volume_backups ? 1 : 0
    asset_id = oci_core_instance.fvtt-instance-1.boot_volume_id
    policy_id = oci_core_volume_backup_policy.fvtt-backup-policy[0].id
}