terraform {
  backend "s3" {
    bucket = "chaga-terraform-remote-state"
    key    = "jupiter/terraform.tfsate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock-my-demo"
  }
}
