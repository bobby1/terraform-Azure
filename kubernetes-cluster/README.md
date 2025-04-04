# terraform-Azure-kubernetes-Cluster
This code is a basic demonstration of ways to create Structured Design Life Cycle (SDLC) deployment cloud environments with minimum effort.  The code uses Terraform to create a Microsoft Azure Kubernetes and VM cluster demonstrating IaC with Azure.

## Design Principles
* Reusable code: The same code base is used for all environments; implementation differences are set based on the environment or tier for the SDLC.
* SDLC from the start: Development (dev), Staging (stg) and Production (prd) folders are available to allow checkout of the code to implement a project using all basic tiers at the beginning of a project.
* Scalable:  the environment setting allows each environment to scale automatically.  Development environments use micro server instance (Standard_B1s) to service a small number of developers, staging environments use medium server instances (Standard_Bats_v2) to allow a large audience to test the application.  Production environments use large server instances (Standard_DS2_v2) to be generally available to the Internet.

  ** This is an alternative to terraform workspace and does not require workspace setup

* Secure: The code shows examples of how to secure user accounts and application accessibility based on environments.
  
  ** Secure Shell Protocol (SSH) keys can be pre-configured and installed on the server to allow secure sessions with all the server instances.
  
  ** Access to the server instances is limited based on the environment.  Dev can be configured to only allow developer access.  Stg can be configured to only allow corporate user access.  Prd can be configured to allow general Internet access.

* Flexible: The code can be customized for individual environments, based on your application needs, for example.  the Azure instance type for each tier can be pre-configured, without the need to have the project specify them for every region. Additional configuration parameters are already in the code to allow for easy customization.  
  
* Auditable: The code creates output and logging where possible.
  ** The public IP and DNS name for servers’ instances created are output in Terraform to allow easy access to the new instance

* Easy to use and maintain:  All code contains a banner with project, usage, pre-requisite and beware sections.  In addition, tags to identify the project, environment and other identifiable information are added where possible.

## Pre-requisites

To use this code base, Azure subscription, and Terraform are required to be installed locally on the server.

   * Azure subscription (https://azure.microsoft.com/en-us/)
  
   * Terraform by HashiCorp (https://www.terraform.io/)
  
## How to use

* To create the example environment using Terraform, in the SDLC directory for the environment to deploy, for example, dev

  $ terraform init

  $ terraform fmt

  $ terraform validate

  $ terraform plan  
        $ terraform plan -out <filename>  is recommended but not required

  $ terraform apply
        $ terraform apply <filename>  if -out was used
  
 
 To view the Kubernetes cluster information, go to the Azure console Kubernetes service page,  https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.ContainerService%2FmanagedClusters to view the newly created K8 cluster.
 

If you no longer need the stack,  you can clean up by using
  $ terraform destroy -auto-approve

* NOTE: You need to have the necessary VM quote to configure the cluster, depending on the VM configures.  You may need to request quota for the virtual machine, based on your Azure subscription.

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
