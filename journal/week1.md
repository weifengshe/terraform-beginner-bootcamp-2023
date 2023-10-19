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
