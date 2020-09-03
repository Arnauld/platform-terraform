#Nom de profil AWS
variable "profile" {
  #Valeur par défaut
  default = "default"
}

variable ssh_key_pub {
  description = "SSH public key installed by default on deployed instance"
}

variable "bastion_eip" {
  default = ""
}

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

variable env_prefix {
  type = string
  default = "dev"
}

variable bastion_accepted_cidr_blocks {
  type = list(string)
  # no filter, accept all
  # use ["123.4.5.6/32"] if you only want ip '123.4.5.6' to be authorized to connect to bastion
  default = ["0.0.0.0/0"]
}

variable bastion {
  type    = string
  default = "vm01"
}

variable cidr {
  type = map(string)
  default = {
    vpc    = "10.0.0.0/16"
    public = "10.0.0.0/24"
    priv_a = "10.0.1.0/24"
  }
}

variable vms {
  type = list(string)
  description = "All vms (name) except the bastion"
  default = ["vm02", "vm03", "vm04", "vm05", "vm06", "vm07", "vm08", "vm09", "vm10"]
}

variable vm_specs {
  type = map(map(string))
  default = {
    "vm01" = {
      "type"      = "t2.micro"
      "ip"        = "10.0.0.101"
      "disk_size" = "8"
      "role"      = "bastion"
    }
    "vm02" = {
      "type"      = "t2.micro"
      "ip"        = "10.0.1.102"
      "disk_size" = "8"
      "role"      = "supervision-ui"
    }
    "vm03" = {
      "type"      = "t3.small"
      "ip"        = "10.0.1.103"
      "disk_size" = "8"
      "role"      = "agent-k3s"
    }
    "vm04" = {
      "type"      = "t3.small"
      "ip"        = "10.0.1.104"
      "disk_size" = "8"
      "role"      = "agent-k3s"
    }
    "vm05" = {
      "type"      = "t3.small"
      "ip"        = "10.0.1.105"
      "disk_size" = "8"
      "role"      = "agent-k3s"
    }
    "vm06" = {
      "type"      = "t2.micro"
      "ip"        = "10.0.1.106"
      "disk_size" = "8"
      "role"      = "master-k3s"
    }
    "vm07" = {
      "type"      = "t2.micro"
      "ip"        = "10.0.1.107"
      "disk_size" = "8"
      "role"      = "master-k3s"
    }
    "vm08" = {
      # t3.large
      "type"      = "t3.medium"
      "ip"        = "10.0.1.108"
      "disk_size" = "16"
      "role"      = "db"
    }
    "vm09" = {
      "type"      = "t3.medium"
      "ip"        = "10.0.1.109"
      "disk_size" = "16"
      "role"      = "db"
    }
    "vm10" = {
      "type"      = "t3.medium"
      "ip"        = "10.0.1.110"
      "disk_size" = "16"
      "role"      = "db"
    }
    "vm11" = {
      "type"      = "t3.medium"
      "ip"        = "10.0.1.111"
      "disk_size" = "16"
      "role"      = "db"
    }
    "vm12" = {
      "type"      = "t3.medium"
      "ip"        = "10.0.1.112"
      "disk_size" = "16"
      "role"      = "db"
    }
    "vm13" = {
      "type"      = "t3.medium"
      "ip"        = "10.0.1.113"
      "disk_size" = "16"
      "role"      = "db"
    }
  }
}