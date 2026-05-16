resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu_24_04.id
  instance_type          = "t2.2xlarge"
  subnet_id              = var.public_subnet_ids
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile_name
  key_name               = var.key_pair_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/tools-install.sh", {})
  tags = {
    Name        = "${var.server_name}-instance"
    Environment = var.environment
  }

}