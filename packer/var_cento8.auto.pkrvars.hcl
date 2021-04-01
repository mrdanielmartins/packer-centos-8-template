# Assign values to override their default values (default values are found in the vsphere_centos8.pkr.hcl file).
# All values are automatically used and persist through the entire Packer process.

vsphere_user     = "example_admin@vsphere.local"
vsphere_password = "secure_Enough_4_u?"

ssh_username = "root"
ssh_password = "secure_Enough_4_u?"

vsphere_template_name = "centos8_x64_packer_template"
vsphere_folder        = "templates"

cpu_num     = 2
mem_size    = 4096
disk_size   = 20000

vsphere_server          = "labvcenter.example"
vsphere_dc_name         = "lab_dc"
vsphere_compute_cluster = "lab_cluster"
vsphere_host            = "labesxi01.example"
vsphere_datastore       = "lab_datastore"
vsphere_portgroup_name  = "lab_test_vm"

os_iso_path = "[lab_datastore] iso/centOS-8.3.2011-x86_64-dvd1.iso"
#ks_iso      = "[lab_datastore] iso/centos_ks.iso"

#builder_ipv4 = "10.20.30.40"