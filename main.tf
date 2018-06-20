variable "access_key" {}
variable "secret_key" {}

provider  "aws" {

  access_key = "${var.access_key}"

  secret_key = " ${var.secret_key}"

  region = "us-east-1"

}

resource "aws_instance" "docker_elk"{

  ami           = "ami-1853ac65"

  instance_type = "t2.micro"

  vpc_security_group_ids = [ "sg-994090d0"]

  key_name = "dock-terra-elk"

  connection {

    user = "ec2-user"

    type = "ssh"

    private_key = "${file("/root/terraform_old/terraformfile_ssh/docker_elk.pem")}"

  }

  provisioner "remote-exec" {

    inline = [ 

    	       "sudo yum install -y docker wget",

               "sudo usermod -aG docker ec2-user",

		"sudo service docker restart",

	       "sudo curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",

               "sudo chmod +x /usr/local/bin/docker-compose",

               "sudo wget -O docker-compose.yml https://github.com/mustu088/docker-compose-elasticsearch.git",

               "sudo service docker restart", 
    ]

  }

  provisioner "remote-exec" {

    inline = [ 

               "docker-compose up -d",

    ]

  }

}
