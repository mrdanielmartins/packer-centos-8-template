# Delcared variables. 

variable "vsphere_template_name" {
  type    = string
}

variable "vsphere_folder" {
  type    = string
}

variable "cpu_num" {
  type    = number
}

variable "disk_size" {
  type    = number
}

variable "mem_size" {
  type    = number
}

variable "vsphere_user" {
  type    = string
  default = "${env("LAB_VSPHERE_USER")}"
}

variable "vsphere_password" {
  type    = string
  default = "${env("LAB_VSPHERE_PASS")}"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_password" {
  type    = string
  default = "${env("LAB_ROOT_PASS")}"
}

variable "vsphere_server" {
  type    = string
}

variable "vsphere_dc_name" {
  type    = string
}

variable "vsphere_compute_cluster" {
  type    = string
}

variable "vsphere_host" {
  type    = string
}

variable "vsphere_datastore" {
  type    = string
}

variable "vsphere_portgroup_name" {
  type    = string
}

variable "os_iso_path" {
  type    = string
}

#variable "ks_iso" {
#  type    = string
#}

#variable "builder_ipv4"{
#  type = string
#  description = "This variable is used to manually assign the IPv4 address to serve the HTTP directory. Use this to override Packer if it utilising the wrong interface."
#}

# Provisioner configuration runs after the main source builder.

build {
  sources = ["source.vsphere-iso.centos"]

  # Upload and execute scripts using Shell
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
    scripts = [
        "scripts/ncpa.sh",
        "scripts/cockpit.sh",
        "scripts/yum_update.sh",
        "scripts/cleanup.sh"
    ]
  }
}

# Builder configuration, responsible for VM provisioning.

source "vsphere-iso" "centos" {

  # vCenter parameters
  insecure_connection   = "true"
  username              = "${var.vsphere_user}"
  password              = "${var.vsphere_password}"
  vcenter_server        = "${var.vsphere_server}"
  cluster               = "${var.vsphere_compute_cluster}"
  datacenter            = "${var.vsphere_dc_name}"
  host                  = "${var.vsphere_host}"
  datastore             = "${var.vsphere_datastore}"
  folder                = "${var.vsphere_folder}"
  vm_name               = "${var.vsphere_template_name}"
  convert_to_template   = true

  # VM resource parameters 
  guest_os_type         = "centos8_64Guest"
  CPUs                  = "${var.cpu_num}"
  CPU_hot_plug          = true
  RAM                   = "${var.mem_size}"
  RAM_hot_plug          = true
  RAM_reserve_all       = false
  notes                 = "Packer built. Access Cockpit on port 9090 and NCPA on port 5693."

  network_adapters {
      network           = "${var.vsphere_portgroup_name}"
      network_card      = "vmxnet3"
  }

  disk_controller_type  = ["pvscsi"]
  storage {
      disk_thin_provisioned = "true"
      disk_size             = var.disk_size
  }

  iso_paths = [
    "${var.os_iso_path}"
    # "${var.ks_iso}" 
  ]

  # CentOS OS parameters
  boot_order            = "disk,cdrom,floppy"
  boot_wait             = "10s"
  ssh_password          = "${var.ssh_password}"
  ssh_username          = "${var.ssh_username}"

  #http_ip = "${var.builder_ipv4}"
  http_directory    = "scripts"
  boot_command      = [
    "<up><wait><tab><wait> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
  ]

  # Uncomment the below to kickstar via an ISO (the ISO you will need to make manually by simply saving the ks.cfg file into an iso file). 
  # I used this in the interim as the box I was running from had issues as Packer kept using a private non-routed network.
  # boot_command = [ 
  #   "<wait15>",
  #   "<tab>",
  #   "linux inst.ks=hd:/dev/sr1:ks.cfg", # Run kickstart off optical drive 2
  #   "<enter>"
  # ]

}