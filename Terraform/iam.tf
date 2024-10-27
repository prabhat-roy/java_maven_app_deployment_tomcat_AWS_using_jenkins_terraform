resource "aws_iam_role" "jenkins_admin_role" {
  name               = "jenkins_admin_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "jenkins_attachment" {
  role       = aws_iam_role.jenkins_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "jenkins_admin_profile" {
  name = "jenkins_admin_profile"
  role = aws_iam_role.jenkins_admin_role.name
}
