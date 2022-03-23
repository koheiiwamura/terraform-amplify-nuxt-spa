output "s3_service_bucket" {
  value = aws_s3_bucket.service.bucket
}

output "s3_service_bucket_domain_name" {
  value = aws_s3_bucket.service.bucket_domain_name
}
