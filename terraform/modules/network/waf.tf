terraform {
  required_version = "~> 1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
      configuration_aliases = [
        aws.use1
      ]
    }
  }
}

data "aws_wafv2_ip_set" "office_vpn" {
  provider = aws.use1
  name     = "office_vpc_for_cloud_front"
  scope    = "CLOUDFRONT"
}

resource "aws_wafv2_web_acl" "service" {
  provider    = aws.use1
  name        = var.service_name
  description = "${var.service_name} access rule. Managed by terraform."
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  rule {
    action {
      allow {}
    }
    name = "office-vpn-only"

    priority = 1
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "waf-${var.service_name}-office-vpn-only"
      sampled_requests_enabled   = false
    }

    statement {
      ip_set_reference_statement {
        arn = data.aws_wafv2_ip_set.office_vpn.arn
      }
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "waf-${var.service_name}"
    sampled_requests_enabled   = false
  }
}
