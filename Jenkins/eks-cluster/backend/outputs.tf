output "s3_bucket_name" {
  description = "The name of the s3 bucket"
  value       = aws_s3_bucket.mern_bucket.id
}

output "kms_key_id" {
  description = "The ID of the KMS key used for encryption"
  value       = aws_kms_key.mykey.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking"
  value       = aws_dynamodb_table.my_table.name
}