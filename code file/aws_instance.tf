resource "aws_instance" "webos1" {
  ami 			  = var.ami_id
  instance_type   = var.instance_type
  associate_public_ip_address = true
  security_groups = ["launch-wizard-4"]
  key_name		  = "terraform_rds"
  
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/AS/Desktop/Terraform LW/terraform_rds.pem")
    host     = aws_instance.webos1.public_ip
  }			  
  provisioner "remote-exec" {
    inline = [
				  "sudo su",
				  "sudo apt-get update",
				  "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add",
				  "sudo add-apt-repository deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable",
				  "sudo apt update",
				  "sudo apt-cache policy docker-ce",
				  "sudo apt install docker-ce",
				  "sudo systemctl status docker",
				  "sudo curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64",
				  "sudo chmod +x ./kind",
				  "sudo mv ./kind /usr/local/bin/kind",
				  "sudo kind create cluster --name velero --image kindest/node:v1.19.1"
    ]
  }
  tags = {
    Name = "velero instance"
  } 
}

