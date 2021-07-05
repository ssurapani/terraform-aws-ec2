# Terraform Variables
variable "region" {
    default = "us-east-1"
}

variable "ami" {
    default = "ami-02354e95b39ca8dec"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "additional_tags" {
    default = {
        Group = "Test Group",
        "CI Environment" = "MyCI",
        "Line of Business" = "My LOB"
    }
}
