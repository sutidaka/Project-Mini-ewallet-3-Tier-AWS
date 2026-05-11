resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = merge(
    {
      Name = "${var.project_name}-bastion"
    },
    var.tags
  )
}

# # Optional: EC2 Instance Connect Endpoint
# resource "aws_ec2_instance_connect_endpoint" "bastion_connect" {
#   subnet_id = var.subnet_id
# }
