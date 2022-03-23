resource "aws_s3_bucket" "service" {
  bucket = "${var.spa_bucket}${var.env_suffix}"
}

resource "aws_s3_bucket_acl" "service" {
  bucket = aws_s3_bucket.service.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "service" {
  bucket = aws_s3_bucket.service.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "service" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.service.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${var.cloudfront_origin_access_identity_iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "service" {
  bucket = aws_s3_bucket.service.id
  policy = data.aws_iam_policy_document.service.json
}
