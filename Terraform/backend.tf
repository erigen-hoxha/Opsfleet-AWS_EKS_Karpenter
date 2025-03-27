# This is optional as assignment does not require state locking.


terraform {
  backend "s3" {
    bucket         = "erigen-opsfleet-bucket"
    key            = "terraform/state/dev/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"  # DynamoDB table for state locking
  }
}
