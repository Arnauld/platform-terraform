#Création d'une ressource "my-vpc" qui utilise des adresses ip en 192.168.0.0/24, donc de 
#192.168.0.0 à 192.168.0.254 (l'adresse 192.168.0.255 étant celle de broadcast).
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  #Desactiver les noms d'hôtes DNS (false par défaut, redondant).
  enable_dns_hostnames = false
  #Activer le support DNS (true par défaut, redondant).
  enable_dns_support = true
  #Gestion de l'instance, par défaut. Possible d'avoir un VPC "dedicated", mais nettement plus cher.
  instance_tenancy = "default"

  #Tags, un système clé:valeur au choix pour trier ses ressources.
  tags = {
    Name = "my-vpc"
  }
}

#Création d'une internet gateway pour garantir l'accès internet depuis ce VPC
resource "aws_internet_gateway" "my-vpc-iwg" {
  #Référence au nom du VPC
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-vpc-iwg"
  }
}

#Ajout du subnet désiré
resource "aws_subnet" "my-vpc-subnet" {
  #A nouveau, le VPC dans lequel on crée le subnet. On préfère une référence à hard-coder le 
  #nom du VPC, ce qui rend les changements faciles.
  vpc_id = aws_vpc.my-vpc.id
  #Ce subnet prend tout l'espace CIDR du VPC
  cidr_block = var.vpc_cidr
  #Permet de fixer l'availability zone utilisée, facultatif. 
  availability_zone = var.aws_availability_zone
  #Ce paramètre permet de faire en sorte qu'une instance lancée dans ce subnet n'a, par défaut, pas 
  #d'IP publique sauf si autrement spécifié.
  map_public_ip_on_launch = false

  tags = {
    Name = "my-vpc-subnet"
  }
}

#On crée une table de routage afin de garantir que les paquets soient envoyés sur internet
resource "aws_route_table" "my-vpc-routing-table" {
  #Il est bien sûr possible de créer plusieurs routes
  route {
    #Tous les packets
    cidr_block = "0.0.0.0/0"
    #Redirigés vers l'internet gateway
    gateway_id = aws_internet_gateway.my-vpc-iwg.id
  }
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-vpc-routing-table"
  }
}

#Une particularité de terraform. L'association se fait automatiquement par la console AWS  
#généralement, mais il est requis de la déclarer sur terraform.
resource "aws_route_table_association" "my-vpc-routing-table-association" {
  #On associe le subnet créé...
  subnet_id = aws_subnet.my-vpc-subnet.id
  #Avec la table de routage précédente.
  route_table_id = aws_route_table.my-vpc-routing-table.id
}

#On crée une access control list pour le VPC (elle sera peu utile ici)
resource "aws_network_acl" "my-vpc-acl" {
  #Il est nécessaire d'y assigner le subnet et le VPC désiré
  vpc_id     = aws_vpc.my-vpc.id
  subnet_ids = [aws_subnet.my-vpc-subnet.id]

  #Permet de contrôler les entrées: Autorisées de tout port vers tout port, tout protocole, toute IP
  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  #Idem pour les sorties: Tout port, tout protocole, toute IP
  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "my-vpc-acl"
  }
}
