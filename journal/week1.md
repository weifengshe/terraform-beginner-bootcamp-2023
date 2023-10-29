# week1 md
# Terraform Beginner Bootcamp 2023 - week 1

## Root Module Struture

```
PROJECT_ROOT
│
├── main.tf                 # to determine the string that needs to be generated ex: AWS s3 bucket
├── variables.tf            # stores the structure of input variables that you want additionally include in the terraform project and workspace
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
├── terraform.tfvars        # the data of variables we want to load into our terraform project
└── README.md               # required for root modules
```


[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input variables 

### Terraform Cloud Variables
In order for us remotely destory the infrastructure, we need to define variables in Terraform Could under Organization. 

In terraform we can set two kinds of variables: 

- Environment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - Those that you would normally set in your tfvars file 

We can set Terraform Could Variables to be sensitive so they are not shown visibly in the UI. 

### Loading Terraform Input Varialbes 
[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Var flag 
We can use the `-var` flag to set an input varialbe or outside a variable in the tfvars file eg. `terraform -var user_uuid="my-user-id"`

### var-file flag 
To set lots of variables, it is more convenient to specify their values in a variable defination file (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file:

```sh 
terraform apply -var-file='testing.tfvars'
```

```
### testing.tfvars configuration would be as below
image_id = "weifeng-abc123"
availability_zone_names = [
    "us-east-1a",
     "us-east-1c"
]
```

### terraform.tvfars 

This is the default file to load in terraform varialbes in remote ex: gitpod, jumppad and this gets automatically processed by terraform

### auto.tfvars 
- This is another way of loading terraform variables that you want to set locally , this can automatically get loaded as well.

Ex: `instance_type = "t2.large"`


### order of terraform variables

-TODO 

![Terraform variable order precedence]()

## Dealing with Configuration Drift 

## What happens if we lose our state file? 

if you lose your statefile, you most likely have to tear down all your cloud infrastrcutre manually. 

You can use terraform import but it won't work for all cloud resources. You need the terraform providers documentation for which resources support import. 

### Fix missing resources with terraform import 
`terraform import aws_s3_bucket.bucket bucket-name`
[Terraform Import](https://developer.hashicorp.com/terraform/language/import)

[AWS S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import) 

### Fix manual configuration 

If someone goes and delete or modified  clould resources manually through clickops. 

if we run terraform plan is with attempt to put our infrastructure back into the expected state fix

### Fix using Terraform Refresh 
```sh 
terraform apply -refresh-only --auto-approve
```

## Terraform Module and Strcture

It is recommended to place modules in a modules directory when locally developing modules but you can mane it what every you like. 

## Passing input varialbes
We can pass input variables to our models. The module has to declare the terraform variables in its own variables.tf 

```
module "terrahouse-aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules sources 
Using the source we can import the module from various places, eg: 

 - locally
 - Github
 - Terraform registry

 ```
 module "terrahouse_aws"{
    source = "./modules/terrahouse_aws"
 }
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources) 

## Terraform-AWS S3 bucket website hosting

### Considerations when using ChatGPT to write terrafomr
LLMs such as ChatGPT may not be trained on the latest documents or information about terraform. 

It may likely generate older examples that could be deprecated. Offen affecting providers. 

### Working with Files in Terraform 
#### Fileexists function 
This is a built in function to check the existance of a file.

```
condition = fileexists(var.error_filepath)
```

[Reference Guide Terraform](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5 
[filemd5 to huandle a file](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path variable
In terraform there is a special variable called path that allows us to reference local paths:

 - path.module = get the path for the current module
 - path.root = get the path for the root[special path variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```
resource "aws_s3_object" "index_html" 

{ 
  
  bucket = aws_s3_bucket.website_bucket.bucket 

  key = "index.html" 

  source = "${path.root}/public/index.html" 
  
  }
  ``` 

### Fix tags 

[how to delete a local and remote tag](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

```sh
### Locally delete a tag
git tag -d <tag-name>

### Remotely delete a tag
git push --delete origin <tag-name>
```

### retag a previous commit 
copy the sha for tha commit 
```sh 
git checkout <sha>
git tag M.M.P
git push --tags
```

## Terraform locals
Locals allows us to define local variables 
It can be very useful when we need transform data into another format and have referenced a variable
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

```tf
locals  {
    s3_origin_id = "MyS3Origin"
}
```

### Terraform Data Sources

This allows us to source data from resources. 
This is useful when we want to reference cloud resources without importing them 
```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources) 


## Working JSON

We use the jsonencode to create the json policy inline in the hcl.


```tf 
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)


### Changing the Lifecycle of Resources  

```tf
lifecycle {
  ignore_changes = [etag]
  replace_triggered_by = [terraform_data.content_version.output]
}
```

[Meta-Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

### Terraform Data
Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

```tf
variable "revision" {
  default = 1
}

resource "terraform_data" "replacement" {
  input = var.revision
}

# This resource has no convenient attribute which forces replacement,
# but can now be replaced by any change to the revision variable value.
resource "example_database" "test" {
  lifecycle {
    replace_triggered_by = [terraform_data.replacement]
  }
}

```

[Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)