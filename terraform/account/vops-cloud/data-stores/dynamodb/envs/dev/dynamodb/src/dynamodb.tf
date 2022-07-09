resource "aws_dynamodb_table" "global-state-consulteanuvem-lock-dynamo" {
  name           = "global-state-consulteanuvem-lock-dynamo"
  hash_key       = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name             = "global-state-consulteanuvem-lock-dynamo"
    Environment      = "globals"
    Application_ID   = "dynamodb"
    Application_Role = "Locks para o Terraform State Files"
    Team             = "consulteanuvem-com-br"
    Customer_Group   = "consulteanuvem-globals"
    RESOURCE         = "environments_at_cloud"
  }
}