# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"  # Replace with your S3 bucket name
#     key            = "path/to/your/terraform.tfstate" # Path to your state file within the bucket
#     region         = "us-east-1"                     # AWS region of your S3 bucket
#     encrypt        = true                            # Enable server-side encryption
#     use_lockfile   = true                            # Enable S3 native state locking
#   }
# }