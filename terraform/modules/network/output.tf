output "cloudfront_origin_access_identity_iam_arn" {
  value = aws_cloudfront_origin_access_identity.service.iam_arn
}
