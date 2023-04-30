resource "aws_instance" "magento_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.type
  key_name        = var.key_name
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.magento_security_group.security_group_id]
  tags = {
    Name = var.ec2_tag
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
    script = "magento/install-ansible.sh"
  }

  provisioner "file" {
    source      = "magento"
    destination = "/tmp/magento"
  }

  provisioner "remote-exec" {
      inline = ["ansible-playbook /tmp/magento/magento-install.yml"]
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