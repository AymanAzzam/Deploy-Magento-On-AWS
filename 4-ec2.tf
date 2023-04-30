resource "aws_instance" "magento_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.type
  key_name        = var.key_name
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.magento_security_group.security_group_id]
  tags = {
    Name = "Magento Instance"
  }
 
# Change the size of created root volume.
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 30
    volume_type           = "gp2"
  }
 
  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = ""
    private_key = file(var.magento_pem_file_path)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "scripts/install-ansible.sh"
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/scripts"
  }

  provisioner "remote-exec" {
      inline = ["ansible-playbook /tmp/scripts/magento-install.yml"]
  }
}

resource "aws_instance" "varnish_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.type
  key_name        = var.key_name
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.varnish_security_group.security_group_id]
  user_data = file("scripts/install-varnish.sh")
  tags = {
    Name = "Varnish Instance"
  }
 
# Change the size of created root volume.
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 30
    volume_type           = "gp2"
  }
}

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

#This is the id of canonical
    owners = ["099720109477"]
}
 
resource "aws_eip" "Instance_IP" {
  instance = aws_instance.magento_instance.id
  vpc = true
}