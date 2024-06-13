# Microsoft Azure resources using Terraform
This code is a basic demonstration of ways to create Structured Design Life Cycle (SDLC) deployment cloud environments with minimum effort.  The code uses Terraform to create a Microsoft Azure Kubernetes cluster.  A basic cluster with monitoring exposed with a public IP illustrates IaC using Azure.

## Design Principles
* Reusable code: The same code base is used for all environments; implementation differences are set based on the environment or tier for the SDLC.
* SDLC from the start: Development (dev), Staging (stg) and Production (prd) folders are available to allow checkout of the code to implement a project using all basic tiers at the beginning of a project.
* Scalable:  the environment setting allows each environment to scale automatically.  Development environments use micro server instances (Standard_B1s) to service a small number of developers, staging environments use medium server instances (Standard_Bats_v2) to allow a large audience to test the application.  Production environments use large server instances (Standard_DS2_v2) to be generally available on the Internet.

  ** In the same manner, dev environments will create two server instances.  Stg environments will create four server instances.  And Prd environments will create six server instances automatically

  ** This is an alternative to terraform workspace and does not require workspace setup

* Secure: The code shows examples of how to secure user accounts and application accessibility based on environments.
  
  ** Secure Shell Protocol (SSH) keys can be pre-configured and installed on the server to allow secure sessions with all the server instances.
  
  ** Access to the server instances is limited based on the environment.  Dev can be configured to only allow developer access.  Stg can be configured to only allow corporate user access.  Prd can be configured to allow general Internet access.

* Flexible: The code can be customized for individual environments, based on your application needs, for example.  the Azure instance type for each tier can be preconfigured, without the need to have the project specify them for every region. Additional configuration parameters are already in the code to allow for easy customization.  
  
* Auditable: The code creates output and logging where possible.
  ** The public IP and DNS name for servers’ instances created are output in Terraform to allow easy access to the new instance

  ** Scripts on servers create a local trail of activity as well as log to the syslog or remote syslogger.

* Easy to use and maintain:  All code contains a banner with project, usage, pre-requisite and beware sections.  In addition, tags to identify the project, environment and other identifiable information are added where possible.

## Pre-requisites

To use this code base, Azure subscription, and Terraform are required to be installed locally on the server.

   * Azure subscription (https://azure.microsoft.com/en-us/)
  
   * Terraform by HashiCorp (https://www.terraform.io/)
  
## How to use
  $ terraform init

  $ terraform fmt

  $ terraform validate

  $ terraform plan  

        $ terraform plan -out <filename>  is recommended but not required

  $ terraform apply
  
        $ terraform apply <filename>  if -out was used
  
 Once the server instance is created, terraform will output the server’s name and IP.  You can retrieve this output at any time after creating the instances by running 
  
   $ terraform output
  
Once you have the new instance DNS name information, connect to each Linux instance to ensure your connection and ssh keys work.

for example:  
  ssh adminuser@01.02.03.04
  and accept the server SSH key into the SSH known-hosts
 
  or
  
  ssh -o StrictHostKeyChecking=accept-new adminuser@ec2-54-92-22-20.compute-1.amazonaws.com    
  to automatically accept the SSH key

For Windows servers:
Once the Windows client is provisioned, you can Remote Desktop to the server using the username adminuser and public IP to the server.

If you no longer need the stack,  you can clean up by using $ terraform destroy -auto-approve

## Roadmap

Please email me for features and additions you would like to see.  

or

## Get Involved

* Submit a proposed code update through a pull request to the `devel` branch.
* Talk to us before making larger changes
  to avoid duplicate efforts. This not only helps everyone
  know what is going on, but it also helps save time and effort if we decide
  some changes are needed.

## Author

Terraform-Azure was created by [Bobby Wen] (https://github.com/bobby1) as a primer to Terraform.

## License

MIT License

https://github.com/bobby1/terraform-Azure/blob/main/LICENSE
