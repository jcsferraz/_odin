resource "aws_dynamodb_table" "global-state-consulteanuvem-lock-dynamo" {
  name           = "global-state-files-consulteanuvem"
  hash_key       = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name             = "global-state-files-consulteanuvem"
    Environment      = "globals"
    Application_ID   = "dynamodb"
    Application_Role = "Locks para o Terraform State Files"
    Team             = "consulteanuvem-com-br"
    Customer_Group   = "consulteanuvem-globals"
    RESOURCE         = "environments_at_cloud"
    BU               = "global"
  }
}