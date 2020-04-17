#Nom de profil AWS
variable "profile" {
  #Valeur par défaut
  default = "default"
}

variable ssh_key_pub {
  description = "SSH public key installed by default on deployed instance"
}

#variable "ip" {
#  #Sans valeur par défaut
#}

variable "aws_region" {
  default = "eu-west-3"
}

variable "aws_availability_zone" {
  default = "eu-west-3a"
}

# ami for ubuntu 18?04 LTS (https://cloud-images.ubuntu.com/locator/ec2/)
variable "ami" {
  type = map(string)

  default = {
    "eu-west-1" = "ami-07b0b243d576296b2" # irlande
    "eu-west-2" = "ami-0eb89db7593b5d434" # london
    "eu-west-3" = "ami-08c757228751c5335" # paris
  }
}

variable bastion_accepted_cidr_blocks {
  type = list(string)
  # no filter, accept all
  # use ["123.4.5.6/32"] if you only want ip '123.4.5.6' to be authorized to connect to bastion
  default = ["0.0.0.0/0"]
}

variable bastion {
  type = map(string)
  default = {
    "name"      = "vm01"
    "type"      = "t2.micro"
    "ip"        = "192.168.0.101"
    "disk_size" = "8"
    "role"      = "bastion"
  }
}

variable vpc_cidr {
  default = "192.168.0.0/24"
}

variable vms {
  type = map(map(string))
  default = {
    "vm02" = {
      "type"      = "t2.micro"
      "ip"        = "192.168.0.102"
      "disk_size" = "8"
      "role"      = "supervision-ui"
    }
    "vm03" = {
      "type"      = "t3.small"
      "ip"        = "192.168.0.103"
      "disk_size" = "8"
      "role"      = "agent-k3s"
    }
    "vm04" = {
      "type"      = "t3.small"
      "ip"        = "192.168.0.104"
      "disk_size" = "8"
      "role"      = "agent-k3s"
    }
    "vm05" = {
      "type"      = "t3.small"
      "ip"        = "192.168.0.105"
      "disk_size" = "8"
      "role"      = "agent-k3s"
    }
    "vm06" = {
      "type"      = "t2.micro"
      "ip"        = "192.168.0.106"
      "disk_size" = "8"
      "role"      = "master-k3s"
    }
    "vm07" = {
      "type"      = "t2.micro"
      "ip"        = "192.168.0.107"
      "disk_size" = "8"
      "role"      = "master-k3s"
    }
    "vm08" = {
      "type"      = "t3.large"
      "ip"        = "192.168.0.108"
      "disk_size" = "16"
      "role"      = "db"
    }
    "vm09" = {
      "type"      = "t3.large"
      "ip"        = "192.168.0.109"
      "disk_size" = "16"
      "role"      = "db"
    }
    "vm10" = {
      "type"      = "t3.large"
      "ip"        = "192.168.0.110"
      "disk_size" = "16"
      "role"      = "db"
    }
  }
}