output "vpc_id" {
  value = "${module.vpc_subnets.vpc_id}"
}

output "public_subnets_id" {
  value = "${module.vpc_subnets.public_subnets_id}"
}

output "private_subnets_id" {
  value = "${module.vpc_subnets.private_subnets_id}"
}

output "ssh_sg_id" {
  value = "${module.ssh_sg.ssh_sg_id}"
}

output "web_sg_id" {
  value = "${module.web_sg.web_sg_id}"
}


output "rds_sg_id" {
  value = "${module.rds_sg.rds_sg_id}"
}


output "ec2_id" {
  value = "${module.ec2.ec2_id}"
}

output "file" {
    value = "${data.template_file.user_data.rendered}"
}
output "rds_address" {
  value = "${module.rds.rds_address}"
}


