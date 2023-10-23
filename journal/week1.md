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

