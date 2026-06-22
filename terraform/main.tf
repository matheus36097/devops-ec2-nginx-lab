provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = file("${path.module}/devops-lab-key.pub")
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  user_data = <<-EOF_SCRIPT
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl enable nginx

              cat > /usr/share/nginx/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <meta charset="UTF-8">
                  <title>Lab DevOps EC2</title>
              </head>
              <body>
                  <h1>Deploy com Terraform + EC2 + Nginx</h1>
                  <p>Servidor criado automaticamente usando user_data.</p>
              </body>
              </html>
              HTML

              systemctl start nginx
              EOF_SCRIPT

  tags = {
    Name        = "${var.project_name}-web"
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}
