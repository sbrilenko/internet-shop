output 'api_id' {
  value = aws_api_gateway.api.id
}

output 'lambda_arn' {
  value = aws_lambda_function.lambda.arn
}

output 'user_pool_id' {
  value = aws_cognito_user_pool.user_pool.id
}

output 'client_id' {
  value = aws_cognito_user_pool_client.client.id
}

output 'bucket_name' {
  value = aws_s3_bucket.bucket.id
}