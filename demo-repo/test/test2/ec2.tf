#Demo EC2 Resource
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  metadata_options {
    http_endpoint = "enabled"
	  http_tokens = "required"
  }	

  tags = {
    Name = "UbuntuTestVM"
  }
}