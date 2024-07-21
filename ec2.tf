data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ec2-sec-gr" {
  name   = "ec2-sec-gr"
  vpc_id = aws_vpc.osrm_vpc.id

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.osrm_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2-sec-gr.id]
  associate_public_ip_address = true

  tags = {
    Name = "osrm"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/${var.key_name}.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "ec2/"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "curl -fsSL https://get.docker.com -o /tmp/get-docker.sh",
      "sudo sh /tmp/get-docker.sh",
      "sudo curl -SL https://github.com/docker/compose/releases/download/v2.28.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "sudo cp osrm.service /etc/systemd/system/osrm.service",
      "sudo service docker start",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable osrm",
      "sudo systemctl start osrm",
    ]
  }
}

resource "aws_ec2_instance_state" "stop" {
  instance_id = aws_instance.ec2.id
  state       = "stopped"
  force       = true
}