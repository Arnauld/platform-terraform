#Créer une paire de clés dans terraform requiert d'utiliser sa clé publique comme matériel. Il est 
#recommandé d'utiliser `$ ssh-keygen -t rsa` pour en créer une et la remplacer ici.
resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = var.ssh_key_pub
  tags = {
    Env  = "${var.env_prefix}-env"
  }
}

#Permet de déclarer un group de sécurité pour EC2, sans quoi il ne sera pas possible d'y accéder
resource "aws_security_group" "my-security-group" {
  #Il est nécessaire de nommer le security group, mais optionnel de lui donner une description
  name        = "my-security-group"
  description = "Allow whitelisted IP in"
  #On rattache le security group au VPC créé précédemment
  vpc_id = aws_vpc.my-vpc.id

  #Sert à définir une règle d'entrée: L'accès à tous les ports, vers tous les ports, tous 
  #protocoles, est possible depuis un certain bloc CIDR
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.bastion_accepted_cidr_blocks
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = []
    self            = true
  }

  #Sert à définir une règle de sortie: Il est possible de sortir vers n'importe où, tous protocoles
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Env  = "${var.env_prefix}-env"
  }

}

resource "aws_eip_association" "eip_assoc" {
  count = var.bastion_eip == "" ? 0 : 1
  instance_id   = aws_instance.my-ec2-bastion.id
  allocation_id = var.bastion_eip
}

#Créons maintenant notre première instance EC2: le bastion
resource "aws_instance" "my-ec2-bastion" {
  #Cette AMI (amazon machine image) 
  ami               = lookup(var.ami, var.aws_region)
  availability_zone = var.aws_availability_zone
  ebs_optimized     = false
  #Inutile de surveiller en détail l'instance (et cela sort du free tier)
  monitoring = false
  #On utilise la clé générée précédemment
  key_name = aws_key_pair.my-key.id
  #L'instance est placée dans le subnet créé précédemment
  subnet_id = aws_subnet.public-subnet.id
  #Et on utilise le security group qu'on a créé
  vpc_security_group_ids = [aws_security_group.my-security-group.id]
  
  #Comme on veut SSH dans l'instance depuis l'internet, il est nécessaire d'associer une IP publique
  associate_public_ip_address = var.bastion_eip == ""
  private_ip                  = lookup(var.vm_specs, var.bastion).ip

  #Les t2.micro sont les plus petites instances disponibles. L'avantage: elles rentrent dans 
  #le free tier de AWS.
  instance_type = lookup(var.vm_types, lookup(var.vm_specs, var.bastion).role).type

  #Il faut un disque de démarrage pour l'instance. On choisit un disque de la taille minimale (8GB), 
  #effacé ors de l'arrêt de l'instance, et de type gp2, c'est à dire "general purpose SSD". La 
  #valeur par défaut étant "standard", ce qui correspond à un disque magnétique, on préfère 
  #utiliser un SSD.
  root_block_device {
    volume_type           = lookup(var.vm_types, lookup(var.vm_specs, var.bastion).role).disk_type
    volume_size           = lookup(var.vm_types, lookup(var.vm_specs, var.bastion).role).disk_size
    delete_on_termination = true
  }

  tags = {
    Role = lookup(var.vm_specs, var.bastion).role
    Name = var.bastion
    Env  = "${var.env_prefix}-env"
  }
}

#Dernièrement, créons l'autre instance EC2 à laquelle on veut accéder à travers le bastion
resource "aws_instance" "my-ec2-server" {
  # Boucle sur toutes les VMs
  for_each = toset(var.vms)
  # ---
  ami                    = lookup(var.ami, var.aws_region)
  availability_zone      = var.aws_availability_zone
  ebs_optimized          = false
  monitoring             = false
  key_name               = aws_key_pair.my-key.id
  subnet_id              = aws_subnet.private-subnet-a.id
  vpc_security_group_ids = [aws_security_group.my-security-group.id]
  #Puisque cette instance doit rester privée, on n'assigne pas d'IP publique
  associate_public_ip_address = false
  #Enfin, on peut également assigner une IP privée fixée de manière à SSH plus simplement.
  private_ip    = lookup(var.vm_specs, each.value).ip
  instance_type = lookup(var.vm_types, lookup(var.vm_specs, each.value).role).type

  root_block_device {
    volume_type           = lookup(var.vm_types, lookup(var.vm_specs, each.value).role).disk_type
    volume_size           = lookup(var.vm_types, lookup(var.vm_specs, each.value).role).disk_size
    delete_on_termination = true
  }

  tags = {
    Role = lookup(var.vm_specs, each.value).role
    Name = each.value
    Env  = "${var.env_prefix}-env"
  }


  #Permet de spécifier un script de démarrage. Ici, pour l'exemple, on peut écrire un fichier 
  #dans /home/ec2-user
  user_data = <<-EOF
	#!/bin/bash
  echo "Hello!" > hello.txt
	EOF
}
