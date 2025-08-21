resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "global-state-files-isengard"
  hash_key       = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name             = "global-state-files-isengard"
    Environment      = "globals"
    Application_ID   = "dynamodb"
    Application_Role = "Locks para o Terraform State Files"
    Team             = "isengard-dev-br"
    Customer_Group   = "isengard-globals"
    Resource         = "environments_at_cloud"
    auto-delete      = "no"
  }
}