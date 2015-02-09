This project contains a terraform sample that fails when you destroy it.

It's launching everything in AWS eu-west.

Test with terraform 3.6

## Usage

Inside of modules/network or in inside sample
```
terraform get # if your testing the sample project
terraform apply -var 'access_key=$YOUR_ACCESS_KEY' -var 'secret_key=YOUR_SECRET_KEY' -var 'allowed_network=$YOUR_NETWORK'
terraform plan -destroy -out destroy.tfplan -var 'access_key=$YOUR_ACCESS_KEY' -var 'secret_key=$YOUR_SECRET_KEY' -var 'allowed_network=$YOUR_NETWORK'
terraform apply destroy.tfplan
```

## Errors example

### For just the module

```
1 error(s) occurred:
* Network vpc-******** has some mapped public address(es). Please unmap those public address(es) before detaching the gateway. (DependencyViolation)
```

### For the sample

```
module.network.aws_route_table_association.public-1: Destroying...
module.network.aws_eip.nat: Destroying...
module.network.aws_route_table_association.private-1: Destroying...
module.network.aws_security_group.allow_bastion: Destroying...
module.network.aws_route_table_association.public-1: Destruction complete
module.network.aws_route_table.public: Destroying...
module.network.aws_route_table_association.private-1: Destruction complete
module.network.aws_route_table.private: Destroying...
module.network.aws_subnet.private-1: Destroying...
module.network.aws_subnet.private-1: Error: Error deleting subnet: The subnet 'subnet-********' has dependencies and cannot be deleted. (DependencyViolation)
module.network.aws_route_table.public: Destruction complete
module.network.aws_internet_gateway.main: Destroying...
module.network.aws_route_table.private: Destruction complete
module.network.aws_eip.nat: Destruction complete
module.network.aws_instance.nat: Destroying...
module.network.aws_internet_gateway.main: Error: Network vpc-******** has some mapped public address(es). Please unmap those public address(es) before detaching the gateway. (DependencyViolation)
module.network.aws_instance.nat: Destruction complete
module.network.aws_security_group.nat: Destroying...
module.network.aws_security_group.nat: Destruction complete
```
