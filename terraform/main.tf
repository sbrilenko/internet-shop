provider 'aws' {
  region = var.region
}

resource 'aws_api_gateway' 'api' {
  name        = 'internet-shop-api'
  description = 'API for internet shop'
}

resource 'aws_api_gateway_resource' 'resource' {
  rest_api_id = aws_api_gateway.api.id
  parent_id   = aws_api_gateway.api.root_resource_id
  path_part   = 'products'
}

resource 'aws_api_gateway_method' 'method' {
  rest_api_id = aws_api_gateway.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = 'GET'
  authorization = 'COGNITO_USER_POOLS'
}

resource 'aws_lambda_function' 'lambda' {
  filename      = 'lambda.zip'
  function_name = 'internet-shop-lambda'
  handler       = 'index.handler'
  runtime       = 'nodejs14.x'
  role          = aws_iam_role.lambda_exec.arn
}

resource 'aws_iam_role' 'lambda_exec' {
  name        = 'internet-shop-lambda-exec'
  description = 'Execution role for lambda'

  assume_role_policy = jsonencode({
    Version = '2012-10-17'
    Statement = [
      {
        Action = 'sts:AssumeRole'
        Effect = 'Allow'
        Principal = {
          Service = 'lambda.amazonaws.com'
        }
      }
    ]
  })
}

resource 'aws_cognito_user_pool' 'user_pool' {
  name                = 'internet-shop-user-pool'
  alias_attributes = ['email', 'phone_number']
}

resource 'aws_cognito_user_pool_client' 'client' {
  name                = 'internet-shop-client'
  user_pool_id       = aws_cognito_user_pool.user_pool.id
  generate_secret     = true
}

resource 'aws_s3_bucket' 'bucket' {
  bucket = 'product-photos'
  acl    = 'private'
}