# Provider spcific
provider "aws" {
    region = "${var.aws_region}"
}

# Variables for VPC module
module "vpc_subnets" {
	source = "./modules/vpc_subnets"
	name = "tendo"
	environment = "dev"
	enable_dns_support = true
	enable_dns_hostnames = true
	vpc_cidr = "172.16.0.0/16"
        public_subnets_cidr = "172.16.10.0/24,172.16.20.0/24"
        private_subnets_cidr = "172.16.30.0/24,172.16.40.0/24"
        azs    = "ca-central-1a,ca-central-1b"
}

module "ssh_sg" {
	source = "./modules/ssh_sg"
	name = "tendo"
	environment = "dev"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "0.0.0.0/0"
}

module "web_sg" {
	source = "./modules/web_sg"
	name = "tendo"
	environment = "dev"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "0.0.0.0/0"
}

module "rds_sg" {
    source = "./modules/rds_sg"
    name = "tendo"
    environment = "dev"
    vpc_id = "${module.vpc_subnets.vpc_id}"
    security_group_id = "${module.web_sg.web_sg_id}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.sh.tpl")}"

}

module "ec2" {
	source = "./modules/ec2"
	name = "tendo"
	environment = "dev"
	server_role = "web"
	ami_id = "ami-06e55c17bfd9792fc"
	key_name = "awsunit"
	count = "2"
	security_group_id = "${module.ssh_sg.ssh_sg_id},${module.web_sg.web_sg_id}"
	subnet_id = "${module.vpc_subnets.public_subnets_id}"
	instance_type = "t2.nano"
	user_data = "${data.template_file.user_data.rendered}"

		
}

module "rds" {
	source = "./modules/rds"
	name = "tendo"
	environment = "dev"
	storage = "5"
	engine_version = "5.6.34"
	db_name = "wordpress"
	username = "root"
	password = "${var.rds_password}"
	security_group_id = "${module.rds_sg.rds_sg_id}"
	subnet_ids = "${module.vpc_subnets.private_subnets_id}"
}