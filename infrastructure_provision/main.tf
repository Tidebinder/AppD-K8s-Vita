locals {
    cluster = {
        master = {
            ip = var.master_ip
            netmask = var.cluster_netmask
            vm_name = var.master_vm_name
            hostname = var.master_hostname
        },
        
        node1 = {
            ip = var.node1_ip
            netmask = var.cluster_netmask
            vm_name = var.node1_vm_name
            hostname = var.node1_hostname
        },

        node2 = {
            ip = var.node2_ip
            netmask = var.cluster_netmask
            vm_name = var.node2_vm_name
            hostname = var.node2_hostname
        }

    }
}


/*
Getting all the info from vCenter
*/
data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}


data "vsphere_compute_cluster" "cluster" {
    name = var.vsphere_cluster
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
    name = var.vsphere_datastore
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "portgroup" {
  name          = var.vsphere_lab_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

/*
Creating a resource pool for the AppD LAB K8s Cluster
*/
resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.vsphere_resource_pool
  parent_resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
}

/*
Creating a folder to store the AppD K8s VMs
*/

resource "vsphere_folder" "folder" {
  path          = "AppD-K8s-VMs"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


/*
Creating the virtual machines for the AppD LAB K8s Cluster
*/
resource "vsphere_virtual_machine" "appd_vm" {
  for_each = local.cluster
  name             = each.value.vm_name
  resource_pool_id = vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder = vsphere_folder.folder.path

  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.portgroup.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = each.value.hostname
        domain    = var.cluster_domain
      }

      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = var.cluster_netmask
      }

      ipv4_gateway = var.cluster_gateway
  }
}
}