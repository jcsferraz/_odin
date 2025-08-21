output "table_names" {
  description = "Names of the DynamoDB tables created"
  value       = [aws_dynamodb_table.terraform_state_lock.name]
}

output "table_arns" {
  description = "ARNs of the DynamoDB tables created"
  value       = [aws_dynamodb_table.terraform_state_lock.arn]
}

output "lock_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}

output "lock_table_arn" {
  description = "ARN of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform_state_lock.arn
}