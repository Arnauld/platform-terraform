#Création d'une ressource "my-vpc" qui utilise des adresses ip en 192.168.0.0/24, donc de 
#192.168.0.0 à 192.168.0.254 (l'adresse 192.168.0.255 étant celle de broadcast).
resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr.vpc
  #Desactiver les noms d'hôtes DNS (false par défaut, redondant).
  enable_dns_hostnames = false
  #Activer le support DNS (true par défaut, redondant).
  enable_dns_support = true
  #Gestion de l'instance, par défaut. Possible d'avoir un VPC "dedicated", mais nettement plus cher.
  instance_tenancy = "default"

  #Tags, un système clé:valeur au choix pour trier ses ressources.
  tags = {
    Name = "${var.env_prefix}-vpc"
    Env  = "${var.env_prefix}-env"
  }
}

## Internet Gateway
#Création d'une internet gateway pour garantir l'accès internet depuis ce VPC
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.my-vpc.id
}

#Ajout du subnet désiré
resource "aws_subnet" "public-subnet" {
  #A nouveau, le VPC dans lequel on crée le subnet.
  vpc_id = aws_vpc.my-vpc.id
  #Ce subnet prend tout l'espace CIDR du VPC
  cidr_block = var.cidr.public
  #Permet de fixer l'availability zone utilisée, facultatif. 
  availability_zone = var.aws_availability_zone
  #Ce paramètre permet de faire en sorte qu'une instance lancée dans ce subnet n'a, par défaut, pas 
  #d'IP publique sauf si autrement spécifié.
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public-subnet"
    Env  = "${var.env_prefix}-env"
  }
}

resource "aws_eip" "nat-eip" {
  vpc = true

  tags = {
    Name = "${var.env_prefix}-nat-eip"
    Env  = "${var.env_prefix}-env"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "${var.env_prefix}-nat"
    Env  = "${var.env_prefix}-env"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  
  tags = {
    Name = "${var.env_prefix}-public-route-table"
    Env  = "${var.env_prefix}-env"
  }
}

resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gateway.id
}

resource "aws_route_table_association" "public-subnet-a" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.cidr.priv_a
  availability_zone = var.aws_availability_zone
  
  tags = {
    Name = "${var.env_prefix}-private-subnet-a"
    Env  = "${var.env_prefix}-env"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table_association" "private-subnet-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
}