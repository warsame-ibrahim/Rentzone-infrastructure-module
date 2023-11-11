locals {
  region       = var.region
  project_name = var.project_name
  enviroment   = var.enviroment
}

#Create vpc module
module "vpc" {
  source                       = "git@github.com:warsame-ibrahim/Terraform-Modules.git//vpc"
  region                       = local.region
  project_name                 = local.project_name
  enviroment                   = local.enviroment
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

# create Nat-gateway
module "nat-gateway" {
  source                     = "git@github.com:warsame-ibrahim/Terraform-Modules.git//nat-gateway"
  project_name               = local.project_name
  enviroment                 = local.enviroment
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

# Create SG-Modules
module "security-groups" {
  source       = "git@github.com:warsame-ibrahim/Terraform-Modules.git//security-groups"
  project_name = local.project_name
  enviroment   = local.enviroment
  vpc_id       = module.vpc.vpc_id
  ssh_ip       = var.ssh_ip
}
#Create RDS-Modules
module "rds" {
  source                       = "git@github.com:warsame-ibrahim/Terraform-Modules.git//rds"
  project_name                 = local.project_name
  enviroment                   = local.enviroment
  private_data_subnet_az1_id   = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id   = module.vpc.private_data_subnet_az2_id
  database_snapshot_identifier = var.database_snapshot_identifier
  database_instance_class      = var.database_instance_class
  availability_zone_1          = module.vpc.availability_zone_1
  database_instance_identifier = var.database_instance_identifier
  multi_az_deployment          = var.multi_az_deployment
  database_security_group_id   = module.security-groups.database_security_group_id

}

# request ssL Certificate
module "ssl_certificate" {
  source          = "git@github.com:warsame-ibrahim/Terraform-Modules.git//acm"
  domain_name     = var.domain_name
  alternative_names = var.alternative_names
}

#Create alb
module "Alb" {
  source                = "git@github.com:warsame-ibrahim/Terraform-Modules.git//Alb"
  project_name          = local.project_name
  enviroment            = local.enviroment
  alb_security_group_id = module.security-groups.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.ssl_certificate.certificate_arn
  target_type           = var.target_type
}

#create S3 for Application
module "s3" {
  source               = "git@github.com:warsame-ibrahim/Terraform-Modules.git//s3"
  project_name         = local.project_name
  env_file_bucket_name = var.env_file_bucket_name
  env_file_name        = var.env_file_name

}