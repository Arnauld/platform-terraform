#Nom de profil AWS
variable "profile" {
  #Valeur par défaut
  default = "default"
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

variable bastion {
  type = map(string)
  default = {
    "name"      = "vm01"
    "type"      = "t2.micro"
    "ip"        = "192.168.0.101"
    "disk_size" = "8"
  }
}

variable vms {
  type = map(map(string))
  default = {
    "vm02" = {
      "type"      = "t2.micro"
      "ip"        = "192.168.0.102"
      "disk_size" = "8"
    }
    "vm03" = {
      "type"      = "t2.micro"
      "ip"        = "192.168.0.103"
      "disk_size" = "8"
    }
    "vm04" = {
      "type"      = "t2.micro"
      "ip"        = "192.168.0.104"
      "disk_size" = "8"
    }
    "vm05" = {
      "type"      = "t2.micro"
      "ip"        = "192.168.0.105"
      "disk_size" = "8"
    }
    "vm06" = {
      "type"      = "t3.small"
      "ip"        = "192.168.0.106"
      "disk_size" = "8"
    }
    "vm07" = {
      "type"      = "t3.small"
      "ip"        = "192.168.0.107"
      "disk_size" = "8"
    }
    "vm08" = {
      "type"      = "t3.large"
      "ip"        = "192.168.0.108"
      "disk_size" = "16"
    }
    "vm09" = {
      "type"      = "t3.large"
      "ip"        = "192.168.0.109"
      "disk_size" = "16"
    }
    "vm10" = {
      "type"      = "t3.large"
      "ip"        = "192.168.0.110"
      "disk_size" = "16"
    }
  }
}