# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository https://github.com/gonzarodz/udacity.git

2. Make any necessary changes to the infrastructure.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)
5. Install [Git](https://git-scm.com/downloads)

### Instructions
Follow these instructions step by step for a successful deployment.

1.	Make sure you are in the correct directory on your terminal.
2.	Login to Azure from the CLI by running <az login>
3.	Define your policy by running the command <az policy definition create --name tagging-policy --rules policy.json>
4.	Assign your policy by running the command <az policy assignment create --policy tagging-policy>
5.	Login to Azure and create a resource group with the same name that you defined in the variables.tf file. We need to create this resource group to run the packer template. You also want to update the server.json file line 19 and update the managed_image_resource_group_name with the name of the resource group you created.
6.	To build your packer image run the command <packer build serve.json>
7.	To initialize Terraform run the command <terraform init>
8.	The next command will be <terraform plan> this will let us define our variables for terraform unless you left the default values.
9.	Lastly run <terraform apply> and this will create all the resources.
10.	If you wish to destroy everything run the command <terraform destroy>

### Output
After a successfull deployment you can login to Azure and you should see your resource group and all resource inside the resource group.

