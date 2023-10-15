# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging. 
[semver.org](https://semver.org/)
Given a version number **MAJOR.MINOR.PATH**, increment the: 

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward bug fixes

### Install the Terraform CLI

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

While fixing the Terraform CLI gpg deprecation issues we notice that bash scripts steps were a considerable amount more code. So we decide to create a bash sctipt to install the Terraform CLI. 

This bash script is located here: [./bin/install.terroform.cli](./bin/install.terroform.cli)  

- This will keep the Gitpod Task File([.gitpod.yml](.gitpod.yml)) tidy. 
- This allow us an easier to debug and execute manually Terraform CLI install
- This will allow better protability for other projects that need to install Terraform CIL.  
How to check the linux version 


#### shebang 
A shebang (pronunced sha-bang) tells the bash script what program that will interpet the scrpt. eg.  `#!/bin/bash`,
`#!/usr/bin/env bash`

- for portability for different os distributions 
- will search the user's PATH. for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Executation considerations  
When execute the bash script we can use `./` shorthand notation to execute the bash script.

eg. `./bin/intall.terraform.cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpert it. 

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

### Github life cycle (Init before command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace. 

https://www.gitpod.io/docs/configure/workspaces/tasks
