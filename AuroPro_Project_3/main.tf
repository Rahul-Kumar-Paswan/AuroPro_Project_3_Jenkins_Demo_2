provider "aws" {
  region     = "${var.region}"
}

terraform {
  backend "s3" {
    bucket          = "auropro-terraform-project-3"
    key             = "Terraform/terraform.tfstate"
    region          = "ap-south-1"
    #dynamodb_table = "Terraform-state-lock"
  }
}

module "my_vpc" {
  source                           = "./modules/network"
  vpc_cidr_block                   = "${var.vpc_cidr_block}"
  env_prefix                       = "${var.env_prefix}"
  public_subnet_cidr_block         = "${var.public_subnet_cidr_block}"
  private_subnet_cidr_block        = "${var.private_subnet_cidr_block}"
  public_subnet_availability_zone  = "${var.public_subnet_availability_zone}"
  private_subnet_availability_zone = "${var.private_subnet_availability_zone}"
}

module "my_instance" {
    source        = "./modules/instances"
    ami_id        = "${var.ami_id}"
    instance_name = "${var.instance_name}"
    instance_type = "${var.instance_type}"
    subnet_id     = module.my_vpc.public_subnet_id
    vpc_id        = module.my_vpc.vpc_id
    env_prefix    = "${var.env_prefix}"
}

module "my_database" {
  source                      = "./modules/database"
  vpc_id                      = module.my_vpc.vpc_id
  subnet_id_1                 = module.my_vpc.public_subnet_id
  subnet_id_2                 = module.my_vpc.private_subnet_id
  env_prefix                  = "${var.env_prefix}"
  db_instance_identifier      = "${var.db_instance_identifier}"
  db_allocated_storage        = "${var.db_allocated_storage}"
  db_engine                   = "${var.db_engine}"
  db_engine_version           = "${var.db_engine_version}"
  db_instance_class           = "${var.db_instance_class}"
  db_name                     = "${var.db_name}"
  db_username                 = "${var.db_username}"
  db_password                 = "${var.db_password}"
  db_multi_az                 = "${var.db_multi_az}"
  db_backup_retention_period  = "${var.db_backup_retention_period}"
  my_security_group_id        = module.my_instance.my_security_group_id
} 