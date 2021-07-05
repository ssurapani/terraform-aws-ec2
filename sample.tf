terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_iam_role" "devops-example-role" {
  name = "devops-example-role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF

  permissions_boundary = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "devops-example-instance-profile" {
  role = aws_iam_role.devops-example-role.id
}

resource "aws_iam_role_policy" "devops-example-role-policy" {
  name = "devops-example-role-policy"
  role = aws_iam_role.devops-example-role.id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "s3:*",
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "devops-example-policy" {
  name = "devops-example-policy"
  description = "A devops example test policy"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:Describe*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "devops-example-role-policy-attach" {
  role = aws_iam_role.devops-example-role.name
  policy_arn = aws_iam_policy.devops-example-policy.arn
}

resource "aws_instance" "ss-test-example" {
  ami = var.ami
  instance_type = var.instance_type

  tags = merge(
    var.additional_tags,
    {
      Name = "Server-ss-text-example"
    }
  )

  iam_instance_profile = aws_iam_instance_profile.devops-example-instance-profile.id
  depends_on = [ aws_iam_role_policy.devops-example-role-policy ]
}

# Creating EBS volume
resource "aws_ebs_volume" "devops-example-data-vol" {
  availability_zone = aws_instance.ss-test-example.availability_zone
  size = 20
  # type = "gp2"
  tags = {
          Name = "devops-example-data-volume"
  }
}

# Attaching EBS volume
resource "aws_volume_attachment" "devops-example-data-vol-att" {
  device_name = "/dev/sdc"
  volume_id = aws_ebs_volume.devops-example-data-vol.id
  instance_id = aws_instance.ss-test-example.id
}
