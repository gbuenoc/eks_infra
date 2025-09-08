# terraform {
#   backend "s3" {
#     bucket         = "bucket_name"
#     key            = "path/terraform.tfstate"
#     region         = "region"
#     dynamodb_table = "table_name"
#   }
# }