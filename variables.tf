variable "aws_region" {
  default = "ap-southeast-1"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "api_gw_name" {
  default = "EC2 API GW"
}

variable "api_gw_queue_name" {
  default = "api_gw"
}

variable "key_name" {
  default = "terraform"
}