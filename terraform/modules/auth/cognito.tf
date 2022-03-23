resource "aws_cognito_user_pool" "admin_authentication" {
  name              = "${var.service_name}${var.env_suffix}-authentication"
  mfa_configuration = "ON"
  password_policy {
    minimum_length                   = 6
    require_numbers                  = true
    require_lowercase                = true
    temporary_password_validity_days = 7
  }
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
  software_token_mfa_configuration {
    enabled = true
  }
}

resource "aws_cognito_user_pool_client" "admin_authentication" {
  name                                 = "admin"
  user_pool_id                         = aws_cognito_user_pool.admin_authentication.id
  generate_secret                      = false
  explicit_auth_flows                  = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  allowed_oauth_scopes                 = ["openid"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = "true"
  callback_urls                        = ["https://${var.subsubdomain}${var.subdomain}${var.domain}/oauth2/idpresponse"]
  refresh_token_validity               = 60
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = ["COGNITO"]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }
  id_token_validity     = 5
  access_token_validity = 5
}

resource "aws_cognito_user_pool_domain" "admin_authentication" {
  domain       = "${var.service_name}${var.env_suffix}-auth"
  user_pool_id = aws_cognito_user_pool.admin_authentication.id
}
