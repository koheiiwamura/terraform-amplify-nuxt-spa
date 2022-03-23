terraform {
  required_version = "~> 1.1.7"
  backend "s3" {

    bucket  = ""
    key     = "common.tfstate"
    region  = "ap-northeast-1"
    encrypt = true

  }

  required_providers {
    aws = {
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

data "aws_caller_identity" "current" {}

# Backend S3 Bucket.
data "aws_s3_bucket" "tfstate" {
  bucket = ""
}

/*
 * The first time you run it, you need to create this Role as a user with other privileges.
 */
# Role for CI of ${var.service_name}.
resource "aws_iam_role" "ci" {
  name = "${var.service_name}-ci"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization_name}/${var.service_name}:*"
          }
        }
      },
    ]
  })
}

/*
 * The first time you run it, you need to create this Role as a user with other privileges.
 */
data "aws_iam_policy_document" "ci_backend_s3" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:Get*"
    ]
    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "s3:Put*"
    ]

    resources = [
      "arn:aws:s3:::${data.aws_s3_bucket.tfstate.bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "ci_backend_s3" {
  name   = "${var.service_name}-ci-backend-s3"
  policy = data.aws_iam_policy_document.ci_backend_s3.json
}

resource "aws_iam_role_policy_attachment" "ci_backend_s3" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_backend_s3.arn
}

/*
 * The first time you run it, you need to create this Role as a user with other privileges.
 */
data "aws_iam_policy_document" "ci_iam" {
  statement {
    actions = [
      "iam:ListAttachedUserPolicies",
      "iam:ListRolePolicies"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:ListPolicyVersions",
      "iam:GetPolicyVersion",
      "iam:GetPolicy",
      "iam:DeletePolicyVersion",
      "iam:DeletePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreatePolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*",
    ]
  }

  statement {
    actions = [
      "iam:PutRolePolicy",
      "iam:ListInstanceProfilesForRole",
      "iam:ListAttachedRolePolicies",
      "iam:GetRolePolicy",
      "iam:GetRole",
      "iam:DetachRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:CreateRole",
      "iam:AttachRolePolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
    ]
  }
  statement {
    actions = [
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:*"
    ]
  }
}

resource "aws_iam_policy" "ci_iam" {
  name   = "${var.service_name}-ci-iam"
  policy = data.aws_iam_policy_document.ci_iam.json
}

resource "aws_iam_role_policy_attachment" "ci_iam" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_iam.arn
}

data "aws_iam_policy_document" "ci_s3" {
  statement {
    actions = [
      "s3:Put*",
      "s3:Get*",
      "s3:CreateBucket",
      "s3:DeleteObject"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ci_s3" {
  name   = "${var.service_name}-ci-s3"
  policy = data.aws_iam_policy_document.ci_s3.json
}

resource "aws_iam_role_policy_attachment" "ci_s3" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_s3.arn
}

data "aws_iam_policy_document" "ci_cloudfront" {
  statement {
    actions = [
      "cloudfront:Create*",
      "cloudfront:Get*",
      "cloudfront:List*",
      "cloudfront:Describe*",
      "cloudfront:TagResource",
      "cloudfront:Update*",
      "cloudfront:PublishFunction"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ci_cloudfront" {
  name   = "${var.service_name}-ci-cloudfront"
  policy = data.aws_iam_policy_document.ci_cloudfront.json
}

resource "aws_iam_role_policy_attachment" "ci_cloudfront" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_cloudfront.arn
}

data "aws_iam_policy_document" "ci_acm" {
  statement {
    actions = [
      "acm:DescribeCertificate",
      "acm:List*"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ci_acm" {
  name   = "${var.service_name}-ci-acm"
  policy = data.aws_iam_policy_document.ci_acm.json
}

resource "aws_iam_role_policy_attachment" "ci_acm" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_acm.arn
}

data "aws_iam_policy_document" "ci_route53" {
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:Get*",
      "route53:List*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ci_route53" {
  name   = "${var.service_name}-ci-route53"
  policy = data.aws_iam_policy_document.ci_route53.json
}

resource "aws_iam_role_policy_attachment" "ci_route53" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_route53.arn
}


data "aws_iam_policy_document" "ci_waf" {
  statement {
    actions = [
      "waf:Create*",
      "waf:Get*",
      "wafv2:Get*",
      "waf:List*",
      "wafv2:List*",
      "wafv2:Create*",
      "waf:UpdateIPSet",
      "waf:UpdateRule",
      "waf:UpdateWebACL",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ci_waf" {
  name   = "${var.service_name}-ci-waf"
  policy = data.aws_iam_policy_document.ci_waf.json
}

resource "aws_iam_role_policy_attachment" "ci_waf" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_waf.arn
}

data "aws_iam_policy_document" "ci_sm" {
  statement {
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:Describe*",
      "secretsmanager:Get*"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ci_sm" {
  name   = "${var.service_name}-ci-sm"
  policy = data.aws_iam_policy_document.ci_sm.json
}

resource "aws_iam_role_policy_attachment" "ci_sm" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_sm.arn
}



resource "aws_iam_policy" "ci_cognito" {
  name   = "${var.service_name}-ci-cognito"
  policy = data.aws_iam_policy_document.ci_cognito.json
}

resource "aws_iam_role_policy_attachment" "ci_cognito" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_cognito.arn
}

data "aws_iam_policy_document" "ci_cognito" {
  statement {
    actions = [
      "cognito-idp:Describe*",
      "cognito-idp:Get*",
      "cognito-idp:Create*",
      "cognito-idp:Set*",
    ]
    resources = [
      "*",
    ]
  }
}
