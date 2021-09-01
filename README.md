# awscodetooldemo
Demo of the AWS Code Tools

# Pre-reqs
Run code from Linux machine (tested with Centos)
AWS CLI
Terraform (greater than v1.0)
Docker
Git
AWS account with sufficient priveleges to deploy resources

# Deployment instructions
Login to AWS (e.g. access / secret access key), temporary command line credentials etc
Navigate to code-tool-creation folder
run 'terraform init'
run 'terraform apply'

# Overview
Demo code for using the AWS Code family to deploy resources using Terraform
To deploy additional resources create folders in the repo created in CodeCommit in repo/test and amend execute.txt to list the directory structure

