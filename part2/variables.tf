variable "aws_access_key" {
  description = "AWS access key"
  default = "${var.access_key}"
}
variable "aws_secret_key" {
  description = "AWS secret key"
  default = "${var.secret_key}"
}
variable "aws_default_region" {
  description = "AWS Region"
  default = "us-east-1"
}
variable "key_path" {
  description = "Public key path"
  default = "${var.pub_key}"
}
variable "ami" {
  description = "AMI"
  default = "ami-4bf3d731" // https://wiki.centos.org/Cloud/AWS
}

variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.micro"
}
