terraform {
  backend "s3" {
    bucket       = "my-awesome-projects-backend"
    key          = "AWS-IoT-Project/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}