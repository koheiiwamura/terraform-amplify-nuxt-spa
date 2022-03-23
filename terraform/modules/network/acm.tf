resource "aws_acm_certificate" "service" {
  provider          = aws.use1
  domain_name       = "*.${var.subdomain}${var.domain}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "asterisk.${var.subdomain}${var.domain}.dns"
  }
}


resource "aws_acm_certificate_validation" "service" {
  provider                = aws.use1
  certificate_arn         = aws_acm_certificate.service.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

