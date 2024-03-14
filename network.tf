# Network resources
resource "oci_core_vcn" "fvtt-vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.fvtt-compartment.id
  dns_label      = var.vcn_dns_label
  display_name   = "fvtt-vcn"
  freeform_tags  = local.common_tags
}

resource "oci_core_subnet" "fvtt-subnet" {
  cidr_block        = "10.1.21.0/24"
  display_name      = "fvtt-subnet"
  dns_label         = var.vcn_dns_label
  security_list_ids = [oci_core_security_list.fvtt-securitylist.id]
  compartment_id    = oci_identity_compartment.fvtt-compartment.id
  vcn_id            = oci_core_vcn.fvtt-vcn.id
  route_table_id    = oci_core_route_table.fvtt-rt.id
  dhcp_options_id   = oci_core_vcn.fvtt-vcn.default_dhcp_options_id
  freeform_tags     = local.common_tags
}

resource "oci_core_internet_gateway" "fvtt-ig" {
  compartment_id = oci_identity_compartment.fvtt-compartment.id
  display_name   = "fvtt-ig"
  vcn_id         = oci_core_vcn.fvtt-vcn.id
  freeform_tags  = local.common_tags
}

resource "oci_core_route_table" "fvtt-rt" {
  compartment_id = oci_identity_compartment.fvtt-compartment.id
  vcn_id         = oci_core_vcn.fvtt-vcn.id
  display_name   = "fvtt-rt"
  freeform_tags  = local.common_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.fvtt-ig.id
  }
}

# Security lists
resource "oci_core_security_list" "fvtt-securitylist" {
  compartment_id = oci_identity_compartment.fvtt-compartment.id
  vcn_id         = oci_core_vcn.fvtt-vcn.id
  display_name   = "fvtt-subnet-sl"
  freeform_tags  = local.common_tags

  egress_security_rules {
      protocol    = "6"
      destination = "0.0.0.0/0"
    }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }



  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }
}
