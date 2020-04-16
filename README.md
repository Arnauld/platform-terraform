```
$ docker run --rm -it --name terraform -v $(pwd):/tf -v ~/.aws:/root/.aws --entrypoint /bin/bash hashicorp/terraform:full
# cd /tf
# terraform apply -var="ip=$AUTHORIZED_IP"
# terraform destroy -var="ip=$AUTHORIZED_IP"
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

* Multiple SSH keys
    * https://stackoverflow.com/a/41486527
