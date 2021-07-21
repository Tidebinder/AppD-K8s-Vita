variable vsphere_user {
    description = "Username of your vCenter, this user need to be able to deploy virtual machines."
}

variable vsphere_password {
    description = "Password of the user that will deploy the virtual machines in your vCenter"
}

variable vsphere_server {
    description = "vCenter IP"
}

variable vsphere_datacenter {
    description = "The name of the datacenter that you want to deploy your AppD lab enviroment"
}

variable vsphere_cluster {
    description = "The name of the cluster that you want to deploy your AppD lab enviroment"
}

variable vsphere_resource_pool {
    description = "The name of the resource pool that will be created for your AppD lab enviroment"
}

variable vsphere_lab_network {
    description = "The name of the port group that will be assigned to the VMs, this network need access to the internet."
}

variable vsphere_datastore {
    description = "The name of the datastore that will be assigned to the VMs, it needs at least 100GB of storage."
}

variable template_name {
    description = "The name of the template that you imported to your vCenter, download it at : ?"
}

variable master_ip {
    description = "IP that will be assigned to the master of the K8s Cluster"
}

variable master_hostname {
    description = "Hostname that will be assigned to the master of the K8S Cluster"
}

variable master_vm_name {
    description = "The name that the master VM will use in vCenter"
}

variable node1_ip {
    description = "IP that will be assigned to the first node of the K8s Cluster"
}

variable node1_hostname {
    description = "Hostname that will be assigned to the first node of the K8S Cluster"
}

variable node1_vm_name {
    description = "The name that the first node VM will use in vCenter"
}

variable node2_ip {
    description = "IP that will be assigned to the second node of the K8s Cluster"
}

variable node2_hostname {
    description = "Hostname that will be assigned to the second node of the K8S Cluster"
}


variable node2_vm_name {
    description = "The name that the second node VM will use in vCenter"
}

variable cluster_gateway {
    description = "The gateway that will be used in all the nodes of the k8s Cluster"
}

variable cluster_netmask {
    type = number
    description = "The netmask that will be used for the network of the K8S cluster, use the number of the CIDR, if it's a /24 just use 24"
}

variable cluster_domain {
    type = string
    description = "The domain that will be used in all the nodes of the K8S Cluster"
}