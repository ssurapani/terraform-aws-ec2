// main.tf
module "workers-us-east-1" {
  source = "workers"
  region = "us-east-1"
  count = 1
  user_data = "${file("user-data-us-east-1.yml")}"
  env = "prod"
}

module "workers-us-west-1" {
  source = "workers"
  region = "us-west-1"
  count = 3
  user_data = "${file("user-data-us-west-1.yml")}"
  env = "prod"
}
