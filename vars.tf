variable "VPC_CIDR_BLOCK" {}
variable "SUB_CIDR_BLOCK" {}
variable "PROJECT_NAME" {}
variable "AZ" {}
variable "PORTS_EC2" {
  type = list(number)
}
variable "PUBLIC_KEY_PATH" {}
variable "PRIVATE_KEY_PATH" {}
variable "EC2_USER" {}
variable "PORTS_ELB" {
  type = list(number)
}
variable "DOMAIN_NAME" {}
