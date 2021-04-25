```
$ docker run --rm -it --name terraform -v $(pwd):/tf -v ~/.aws:/root/.aws --entrypoint /bin/bash hashicorp/terraform:full
# cd /tf
# export VMS='vms=["front2", "back01", "back02", "back03", "proxy1", "proxy2", "data01", "data02", "data03", "es01", "es02", "es03"]'
# export VMS='vms=["front2", "back01", "back02", "proxy1", "data01", "data02"]'
# terraform plan    -var-file="vars/rss.tfvars" -var-file="vars/private.tfvars" -var="$VMS"
# terraform apply   -var-file="vars/rss.tfvars" -var-file="vars/private.tfvars" -var="$VMS"
# terraform destroy -var-file="vars/rss.tfvars" -var-file="vars/private.tfvars" -var="$VMS"
```

```
terraform plan -var-file="vars/mentem.tfvars" -var-file="vars/private.tfvars" -var='vms=["vm09", "vm10"]'
```

```
$ curl ipecho.net/plain ; echo
$ AUTHORIZED_IP=
```

# References

EC2 instances types
* https://aws.amazon.com/fr/ec2/instance-types/

Terraform variables
* https://discuss.hashicorp.com/t/terraform-tfvars-versus-variables-tf-differences/3351/2
* https://www.terraform.io/docs/configuration/variables.html

"best practices"
* https://upcloud.com/community/stories/terraform-best-practices-beginners/

Misc

* https://www.mrjamiebowman.com/devops/running-terraform-in-docker-locally/
* https://blog.stack-labs.com/code/terraform_deployer_infra_en_quelques_commandes/
* https://www.bogotobogo.com/DevOps/Terraform/Terraform-creating-multiple-instances-count-list-type.php
* https://blog.octo.com/creer-des-instances-aws-qui-ont-acces-a-internet-sans-ip-publique-avec-terraform/

* Multiple SSH keys
    * https://stackoverflow.com/a/41486527
