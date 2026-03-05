resource "aws_instance" "nat_instance" {
  ami                         = var.ami_id
  instance_type               = var.nat_instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  source_dest_check           = false
  vpc_security_group_ids = [var.security_group_id]

# Script forward traffic nat-instance 
  user_data = <<-EOF
              #!/bin/bash
              sysctl -w net.ipv4.ip_forward=1
              echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
              iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              yum install -y iptables-services
              systemctl start iptables
              systemctl enable iptables
              service iptables save
              systemctl restart iptables
              EOF

  # Tagging เพื่อการจัดการง่าย
  tags = merge(
    {
      Name = "${var.project_name}-nat_instance"
    },
    var.tags
  )
}


# Elastic IP สำหรับ NAT Instance
resource "aws_eip" "nat_eip" {
  instance = aws_instance.nat_instance.id
  # vpc = true 

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}
