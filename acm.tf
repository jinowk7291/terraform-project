resource "aws_acm_certificate" "kubedns" {
  subject_alternative_names = ["argocd.kubends.com"]
  domain_name       = "kubedns.click"
  validation_method = "DNS"
}

resource "aws_route53_record" "kubedns" {
  for_each = {
    for dvo in aws_acm_certificate.kubedns.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      zone_id = "${aws_route53_zone.kubedns.zone_id}"
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "kubedns" {
  certificate_arn         = "${aws_acm_certificate.kubedns.arn}"
  validation_record_fqdns = [for record in aws_route53_record.kubedns : record.fqdn]
  timeouts {
    create = "20m"
  }
}
