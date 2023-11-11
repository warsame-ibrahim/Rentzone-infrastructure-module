#Enviroment Variables
variable "region" {}
variable "project_name" {}
variable "enviroment" {}

#Vpc Variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}

#SG Variables
variable "ssh_ip" {}

#RDS Variables
variable "database_snapshot_identifier" {}
variable "database_instance_class" {}
variable "multi_az_deployment" {}
variable "database_instance_identifier" {}

#Ssl Variables
variable "domain_name" {}
variable "sub_domain_name" {}

#ALB Variables
variable "target_type" {}

#S3 Variables
variable "env_file_bucket_name" {}
variable "env_file_name" {}


