resource "oci_identity_compartment" "fvtt-compartment" {
    # Required
    compartment_id = var.tenancy_ocid
    description = "Compartment for FVTT resources."
    name = var.compartment_name
}