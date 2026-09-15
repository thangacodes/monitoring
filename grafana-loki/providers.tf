provider "aws" {
  region                   = var.aws_region
  profile                  = "captain"
  shared_credentials_files = ["/home/demo/.aws/credentials"]
}
