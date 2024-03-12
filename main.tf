# defindo o provedor
provider "aws" {
    region  = "us-east-1"
    # acess key
    access_key = ""
    # secret key
    secret_key = ""
}

# definindo a instancia
resource "aws_instance" "webserver" {
    ami = "ami-06cc514f1012a7431"
    instance_type = "t2.micro"

    security_groups = [aws_security_group.sg-030e6e47d157df14e.name]
    key_name = aws_key_pair.pubkey.key_name

    tags = {
        "Name" = "Win-Webserver"
    }
}

# security_group
resource "aws_security_group" "sg-030e6e47d157df14e" {
    name ="Allow all"

    # Inbound
    ingress{
        from_port       = 0 
        to_port         = 6556
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]

    }
    # Outbond
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = { 
        Name = "sg-Win-Webserver"
    }
}

resource "aws_key_pair" "pubkey" {
    key_name = "demo_windows"
    public_key = file("key/demo-key.pub")
    }

# EIP
resource "aws_eip" "elasticip" {
    instance = aws_instance.webserver.id
}

# Output EIP
output "eip" {
    value = aws_eip.elasticip.public_ip
}






