resource "aws_route53_zone" "kubedns" {
    name = "kubedns.click"
    force_destroy = true
}
output "name_server" {
  value = aws_route53_zone.kubedns.name_servers
}
