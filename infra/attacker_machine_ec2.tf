resource "aws_instance" "attacker-server" {
  ami = "ami-0e6709a5d0b923603"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.code2cloud-public-subnet-1.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.code2cloud-ec2-ssh-security-group.id}"
    ]
    key_name = "${aws_key_pair.code2cloud-ec2-key-pair.key_name}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 60
        delete_on_termination = true
    }
    
    
    provisioner "file" {
      source = "scripts/exploit/exploit.py"
      destination = "/home/ubuntu/exploit.py"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
        agent = "false"
      }
    }

    provisioner "file" {
      source = "scripts/exploit/aws_service_enum/aws_service_enum.py"
      destination = "/home/ubuntu/aws_service_enum.py"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "scripts/exploit/aws_service_enum/commands_list.txt"
      destination = "/home/ubuntu/commands_list.txt"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "scripts/exploit/requirements.txt"
      destination = "/home/ubuntu/requirements.txt"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "../app"
      destination = "/home/ubuntu/code/"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
        agent = "false"
      }
    }

    provisioner "file" {
      source = "../infra"
      destination = "/home/ubuntu/code/"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
        agent = "false"
      }
    }

    provisioner "file" {
      source = "scripts/config"
      destination = "/home/ubuntu/config"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "../../../code2cloud_cloud_breach/.gitignore"
      destination = "/home/ubuntu/code/.gitignore"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
        agent = "false"
      }
    }

    provisioner "file" {
      source = "../../../code2cloud_cloud_breach/Jenkinsfile"
      destination = "/home/ubuntu/code/Jenkinsfile"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
        agent = "false"
      }
    }

    provisioner "file" {
      source = "ide/docker-compose.yml"
      destination = "/home/ubuntu/docker-compose.yml"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "ide/Dockerfile"
      destination = "/home/ubuntu/Dockerfile"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "scripts/install_ide_script.sh"
      destination = "/home/ubuntu/install_ide_script.sh"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "scripts/Bridgecrew.checkov-1.0.93.vsix"
      destination = "/home/ubuntu/Bridgecrew.checkov-1.0.93.vsix"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "./panw"
      destination = "/home/ubuntu/server"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "file" {
      source = "./panw.pub"
      destination = "/home/ubuntu/server.pub"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.ssh-private-key-for-ec2)}"
        host = self.public_ip
      }
    }

    provisioner "remote-exec" {
      inline = [
        "sudo pip install -r requirements.txt",
        "sudo systemctl stop jenkins.service",
        "sudo apt remove awscli -y",
        "sudo pip3 install awscli",
        "sudo mv /usr/local/bin/aws /usr/bin/",
        "sudo apt install jq -y",
        "chmod +x /home/ubuntu/install_ide_script.sh",
        "/home/ubuntu/install_ide_script.sh"
      ]
      connection {
          type = "ssh"
          user = "ubuntu"
          private_key = "${file(var.ssh-private-key-for-ec2)}"
          host = self.public_ip
      }
    }

    tags = {
        Name = "code2cloud-attacker-ec2-${var.code2cloudid}"
        Stack = "${var.stack-name}"
        Scenario = "${var.scenario-name}"
    }
}

output "attacker-server" {
  value = aws_instance.attacker-server.public_ip
}