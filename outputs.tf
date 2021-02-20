output "wordpress_instance_id" {
  value       = aws_instance.ec2_wordpress.id
  description = "Id of AWS web_server_instance"
}

output "wordpress_ip_addr" {
  value       = aws_eip.my_static_ip.public_ip
  description = "Wordpress public IP"
}

output "wordpress_db_hostname" {
  value       = aws_db_instance.wordpress_db.address
  description = "Wordpress Database Hostname"
}
