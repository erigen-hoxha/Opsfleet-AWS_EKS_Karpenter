# This is optional as assignment does not require state locking.


terraform {
  backend "s3" {
    bucket         = "Opsfleet-bucket"  # Replace with your S3 bucket name
    key            = "terraform/state/dev/terraform.tfstate"
    region         = "us-west-x"
    encrypt        = true
    dynamodb_table = "terraform-locks"  # DynamoDB table for state locking
  }
}
