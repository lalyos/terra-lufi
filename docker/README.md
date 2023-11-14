## Links

- https://registry.terraform.io/browse/providers
- https://github.com/lalyos/terra-lufi

## Exercise Docker

```
mkdir terra-lufi
cd $_
touch main.tf
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
terraform apply  -var port=8081 -var tag=latest
terraform apply -var-file=dev.tfvars
export TF_VAR_food=tokfozelek
# equivalent to using `-var food=tokfozelek`

```
but `terraform.tfvars` is used automatically!

## Console

The command `terraform console` gives you an interactive prompt to play with:
- references:
```
var.port
resource_type.name
resource_type.name.arg1
resource_type.name.arg1.subarg
resource_type.name.list[0].subarg

yamldecode(file("servers.yaml"))

"port is ${var.port}"
```

## Output

```
output "url" {
  value = "http://127.0.0.1:${docker_container.nginx.ports[0].external}"
}
```

See outputs (prevoius apply)
```
terraform output
```

See only specific output:
```
terraform output url
terraform output -raw url
```

## Poorman's auto open
```
terraform apply -auto-approve && open $(terraform output -raw url)
```

## Separate blocks to files

Common filenames:
- main.tf
- variables.tf
- outputs.tf
- terraform.tfvars

