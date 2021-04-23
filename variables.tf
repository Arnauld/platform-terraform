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
  default = "front1"
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
  default = ["front2", "back01", "back02", "back03", "proxy1", "proxy2", "data01", "data02", "data03", "es01", "es02", "es03"]
}

variable vm_types {
  type = map(map(string))
  default = {
    "front" = {
      "type"      = "t2.micro"
      "disk_size" = "8"
      "disk_type" = "gp2"
    }
    "proxy"= { 
      "type"      = "t2.micro"   
      "disk_size" = "8"
      "disk_type" = "gp2"
    }
    "back" = { 
      "type"      = "t3.medium"  
      "disk_size" = "8"
      "disk_type" = "gp2"
    }
    "data" = { 
      "type"      = "t3.medium"  
      "disk_size" = "16"
      "disk_type" = "gp2"
    }
    "es"   = { 
      "type"      = "t3.medium"  
      "disk_size" = "16"
      "disk_type" = "gp2"
    }
  }
}

variable vm_specs {
  type = map(map(string))
  default = {
    "front1" = {
      "ip"        = "10.0.0.101"
      "role"      = "front"
    }
    "front2" = {
      "ip"        = "10.0.1.102"
      "role"      = "front"
    }
    "back01" = {
      "ip"        = "10.0.1.103"
      "role"      = "back"
    }
    "back02" = {
      "ip"        = "10.0.1.104"
      "role"      = "back"
    }
    "back03" = {
      "ip"        = "10.0.1.105"
      "role"      = "back"
    }
    "proxy1" = {
      "ip"        = "10.0.1.106"
      "role"      = "proxy"
    }
    "proxy2" = {
      "ip"        = "10.0.1.107"
      "role"      = "proxy"
    }
    "data01" = {
      "ip"        = "10.0.1.108"
      "role"      = "data"
    }
    "data02" = {
      "ip"        = "10.0.1.109"
      "role"      = "data"
    }
    "data03" = {
      "ip"        = "10.0.1.110"
      "role"      = "data"
    }
    "es01" = {
      "ip"        = "10.0.1.111"
      "role"      = "es"
    }
    "es02" = {
      "ip"        = "10.0.1.112"
      "role"      = "es"
    }
    "es03" = {
      "ip"        = "10.0.1.113"
      "role"      = "es"
    }
  }
}
