data "aws_caller_identity" "current" {}

resource "aws_cloudfront_origin_access_identity" "service" {
}

resource "aws_cloudfront_distribution" "service" {
  depends_on      = [aws_acm_certificate.service]
  enabled         = true
  is_ipv6_enabled = true
  aliases         = ["${var.subsubdomain}${var.subdomain}${var.domain}"]
  web_acl_id      = aws_wafv2_web_acl.service.arn
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.service.arn
    ssl_support_method  = "sni-only"
  }
  origin {
    domain_name = var.s3_service_bucket_domain_name
    origin_id   = "S3-${var.s3_service_bucket}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.service.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "S3-${var.s3_service_bucket}"
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.service.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_function" "service" {
  name    = "${var.service_name}${var.env_suffix}-add-path-to-url"
  runtime = "cloudfront-js-1.0"
  comment = "add /index.html to uri"
  publish = true
  code    = file("${path.module}/functions/add_path_to_url.js")
}
