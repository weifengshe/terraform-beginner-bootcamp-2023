- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
    + [Consideration with the Terraform CLI changes](#consideration-with-the-terraform-cli-changes)
    + [Considerations for linux distribution](#considerations-for-linux-distribution)
    + [Refactoring into bash scripts](#refactoring-into-bash-scripts)
    + [shebang](#shebang)
    + [Executation considerations](#executation-considerations)
    + [Linux  permission considerations](#linux--permission-considerations)
  * [Github life cycle](#github-life-cycle)
  * [Working with Env vars](#working-with-env-vars)
    + [Setting and unsetting env vars](#setting-and-unsetting-env-vars)
    + [Printting Vars](#printting-vars)
    + [scopinng of Env Vars](#scopinng-of-env-vars)
    + [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
  * [AWS CLI installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terrafrom Registry](#terrafrom-registry)
  * [Terraform Console](#terraform-console)
  * [Terrafomr Init](#terrafomr-init)
  * [Terraform Plan](#terraform-plan)
  * [Terraform Apply](#terraform-apply)
  * [Terraform Lock Files](#terraform-lock-files)
  * [Terraform State Files](#terraform-state-files)
  * [Terraform Directory](#terraform-directory)
  * [Terraform Destroy](#terraform-destroy)
- [Issues with Terraform cloud login and Gitpod workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)


## Semantic Versioning 

This project is going to utilize semantic versioning for its tagging. 
[semver.org](https://semver.org/)
Given a version number **MAJOR.MINOR.PATH**, increment the tag ex: `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward bug fixes

## Install the Terraform CLI for Linux

#### Consideration with the Terraform CLI changes 
The terraform CLI installation instruction have been changed due to gpg keyring changes. So we need to refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install. 
[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 

#### Considerations for linux distribution 

This project is built against ubuntu 
Please check your linux distribution needs.
[How to check OS version in linux](
https://opensource.com/article/18/6/linux-version
) 

Example of checking os version 
``` 
$ cat /etc/os-release 

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

#### Refactoring into bash scripts 

While fixing the Terraform CLI gpg deprecation issues we notice that bash script steps were a considerable amount more code. So we decide to create a bash script to install the Terraform CLI. 

This bash script is located here: [./bin/install.terroform.cli](./bin/install.terroform.cli)  

- This will keep the Gitpod Task File([.gitpod.yml](.gitpod.yml)) tidy. 
- This allows us eazier to debug and execute manually Terraform CLI install
- This will allow better portability for other projects that need to install Terraform CIL.  

#### shebang 
A shebang (pronunced sha-bang) tells the bash script what program that will interpret the script. eg.  `#!/bin/bash`,
`#!/usr/bin/env bash`

- for portability for different os distributions 
- will search the user's PATH. for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Executation considerations  
When executing the bash script we can use `./` shorthand notation to execute the bash script.

eg. `./bin/intall.terraform.cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it. 

eg. `source ./bin/install.terraform.cli`

#### Linux  permission considerations

https://en.wikipedia.org/wiki/Chmod

In order to make our bash scripts executable we need to change linux permission for the fix to be executable 

```sh 
chmod u+x /bin/intall.terraform.cli
``` 

alternatively
```sh 
chmod 744 /bin/intall.terraform.cli
``` 

### Github life cycle init-before

We need to be careful when using the Init because it will not rerun if we restart an existing workspace. 

https://www.gitpod.io/docs/configure/workspaces/tasks


### Working with Env vars

We can list out all Environment Variables (Env Vars) using `env` command

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and unsetting env vars

In the terminal we can set using `export HELLO='word'`

We can unset the var using `unset HELLO`

We can set an env var temporarily when just running a command 

```sh
HELLO='WORLD' ./bin/print_message
```

Within a bash script we can set env var without writing export eg.

```sh
#!/usr/bin/env bash 
HELLO='world' 

echo $HELLO

```

#### Printing Vars 

We can print an env var using echo eg. `echo $HELLO` 

#### Scoping of Env Vars 

When you open up new bash terminals in VS code it will not be aware of env vars that you have set in another window. 

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg `.bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in gitpod secrets storage

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces 

You can also set env vars in the `.gitpod.yml`, but it only can have non-sensitve var.  


### AWS CLI installation

AWS CLI is installed for the project via bash script [./bin/install_aws_cli](./bin/install_aws_cli)

[Getting started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 
[AWS CLI ](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like this: 

```json
{
    "UserId": "AIDA6N7FGXF3IMKE7N4JW",
    "Account": "992081262966",
    "Arn": "arn:aws:iam::992081262966:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CIL credentials from IAM user in order to the user AWS CIL. 


## Terraform Basics

### Terrafrom Registry

Terrafrom sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Provider** is an interface to APIs that will allow to create resources in terraform. 
- **Modules** are a way to make a large amount of terraform code modular, portable and sharable. 
[Random Terraform provider](https://registry.terraform.io/providers/hashicorp/random/)

### Terraform Console 

We can see a list of all the Terraform commands by simply typing `terraform`

### Terrafomr Init

at the start of a new terraform project we will run `terraform init` to download the binaries for the terraform provides that we'll use in the project. 

### Terraform Plan 
`terraform plan`

This will generate out a changeset, about the state of our infrastructure and whill be changed 

We can output this changeset is. "plan" to be passed to an apply, but often you can just ignore

### Terraform Apply 

`terraform apply`

This will run a plan and pass the changeset to be execute by terraform. Apply should prompt us yes or not, if we want to automatically approve we can provider the auto approve flag eg. `terraform apply --auto-approve`

### Terraform Lock Files

`.terraform.loc.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The terraform loc file should be committed to your version control system (VCS) eg. Github  

### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure. 

This file **should not be committed** to your VCS. 

This file can contain sensitive data. 

If you lose this file, you lose knowning the state of your infrastructure

`.terraform.tfstate.backup` is the previous state file state.

### Terraform Directory

`.terraform` directory contains binaries of terraform providers.


### Terraform Destroy
`terraform destroy`
This will destroy resources


## Issues with Terraform cloud login and Gitpod workspace

When attempting to run `terraform login` it will launnch bash wiswig view to generate a token. However it does not work as expected in Gitpod VsCode in the browser. 

The workaround is manually generate a token in Terraform cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```
The create and open the file manually here 

```sh 
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

We have automated the workaround with the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials) 
