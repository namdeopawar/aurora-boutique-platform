terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }
}

resource "aws_iam_user" "jenkins" {
  name = "${var.name}-jenkins"
}

resource "aws_iam_user_policy_attachment" "jenkins_power" {
  user       = aws_iam_user.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

output "jenkins_user_name" {
  value = aws_iam_user.jenkins.name
}
