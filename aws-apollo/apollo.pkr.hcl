packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

############################
# VARIABLES
############################
variable "region" {
  type    = string
  default = "us-east-1"          # Cámbialo a tu región
}

variable "instance_type" {
  type    = string
  default = "t2.micro"           # Free Tier x86-64
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"             # Usuario por defecto en las AMIs de Ubuntu
}

############################
# BUILDER (amazon-ebs)
############################
source "amazon-ebs" "apollo_server_ami" {
  region                       = var.region
  instance_type                = var.instance_type
  ssh_username                 = var.ssh_username

  ami_name                     = "ami-apollo-server-{{timestamp}}"
  associate_public_ip_address  = true

  # Última Ubuntu 22.04 LTS x86-64 (HVM, EBS root)
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      "root-device-type"  = "ebs"
      "virtualization-type" = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]  # Canonical
  }

  tags = {
    Name      = "AMI Apollo Server"
    ManagedBy = "Packer"
  }
}

############################
# BUILD BLOCK
############################
build {
  name    = "apollo_server_ami"
  sources = ["source.amazon-ebs.apollo_server_ami"]

  ################################
  # 1. Instalación de Docker + Compose
  ################################
  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
      # Instalar Docker CE desde repositorio oficial
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo systemctl enable --now docker",
      # Permisos para el usuario
      "sudo usermod -aG docker ${var.ssh_username}"
    ]
  }

  ################################
  # 2. Preparar directorio y copia del proyecto
  ################################
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /home/${var.ssh_username}/app",
      "sudo chown ${var.ssh_username}:${var.ssh_username} /home/${var.ssh_username}/app"
    ]
  }

  provisioner "file" {
    source      = "./"                     
    destination = "/home/${var.ssh_username}/app"
  }


  ################################
  # 3. Arranque y servicio systemd
  ################################
  provisioner "shell" {
    inline = [
      "cd /home/${var.ssh_username}/app",
      # Usando plugin docker compose v2: `docker compose ...`
      "sudo docker compose build",
      "sudo docker compose up -d",
      # Servicio para que Compose arranque al boot
      "sudo bash -c 'cat >/etc/systemd/system/app-compose.service <<EOF\n[Unit]\nDescription=Docker Compose GraphQL+Nginx\nRequires=docker.service\nAfter=docker.service\n\n[Service]\nType=oneshot\nRemainAfterExit=yes\nWorkingDirectory=/home/${var.ssh_username}/app\nExecStart=/usr/bin/docker compose up -d\nExecStop=/usr/bin/docker compose down\n\n[Install]\nWantedBy=multi-user.target\nEOF'",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable app-compose.service"
    ]
  }

  # Limpieza opcional para minimizar el tamaño
  provisioner "shell" {
    inline = [
      "sudo apt-get clean",
      "sudo rm -rf /var/lib/apt/lists/*"
    ]
  }
}
