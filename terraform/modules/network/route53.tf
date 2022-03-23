data "aws_route53_zone" "service" {
  name = "${var.domain}."
}

resource "aws_route53_record" "service" {
  zone_id = data.aws_route53_zone.service.zone_id
  name    = "${var.subsubdomain}${var.subdomain}${data.aws_route53_zone.service.name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.service.domain_name
    zone_id                = aws_cloudfront_distribution.service.hosted_zone_id
    evaluate_target_health = "false"
  }
}


resource "aws_route53_record" "validation" {
  depends_on = [aws_acm_certificate.service]
  zone_id    = data.aws_route53_zone.service.id
  ttl        = 60

  for_each = {
    for dvo in aws_acm_certificate.service.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  allow_overwrite = true
}
