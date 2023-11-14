


## Links

- http://bit.ly/terra-lufi
- https://registry.terraform.io/browse/providers


## Exercise Docker

```
mkdir terra-lufi
cd $_
terraform init
```

add some provider/resource to main.tf

check what would happen
```
terraform plan
terraform plan -out=fist.tfplan
terraform plan -out fist.tfplan
```

do it
```
terraform apply # type: yes
terraform apply fist.tfplan
terraform apply -auto-approve
```

### Variables

```
variable "port" {
  description = "Port to expose"
  default = 8080
}
```

how to ref a variable

```
  argument = var.port
  literar = "something: ${var.port} ${type.name.arg}"
```


apply with custom variable values (other than default)
```
terraform
```

## Console

The command `terraform console` gives you an interactive prompt to play with:
- references:
```
var.port
resource_type.name
resource_type.name.arg1
resource_type.name.arg1.subarg
resource_type.name.list[0].subarg

"port is ${var.port}"
```

## Output

```
output "url" {
  value = "http://127.0.0.1:${docker_container.nginx.ports[0].external}"
}
```