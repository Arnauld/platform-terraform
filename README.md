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

* https://www.mrjamiebowman.com/devops/running-terraform-in-docker-locally/
* https://blog.stack-labs.com/code/terraform_deployer_infra_en_quelques_commandes/
* https://www.bogotobogo.com/DevOps/Terraform/Terraform-creating-multiple-instances-count-list-type.php