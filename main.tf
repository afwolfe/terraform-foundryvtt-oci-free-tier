
# Create SSH keys
resource "tls_private_key" "fvtt-instance-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "fvtt-instance-ssh-key" { 
  filename = "${path.module}/fvtt-instance-ssh-key.pem"
  content = tls_private_key.fvtt-instance-ssh-key.private_key_pem
  file_permission = 0600
}

# Computing resources
resource "oci_core_instance" "fvtt-instance-1" {
  availability_domain = local.availability_domain[0]
  compartment_id      = oci_identity_compartment.fvtt-compartment.id
  display_name        = "fvtt-instance-1"
  shape               = local.instance_shape
  freeform_tags       = local.common_tags

  create_vnic_details {
    subnet_id        = oci_core_subnet.fvtt-subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "fvtt-instance-1"
  }

  source_details {
    source_type = "image"
    source_id   = local.images[var.region]
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.fvtt-instance-ssh-key.public_key_openssh
  }

  state = var.instance_state
}

resource "local_file" "AnsibleInventory" {
 content = templatefile("templates/ansible-inventory.tmpl",
 {
  fvtt-instance-1-ip = oci_core_instance.fvtt-instance-1.public_ip
 }
 )
 filename = "ansible/inventory"
}
