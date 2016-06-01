# SparkNow
Using SparkNow you can rapidly deploy, scale and tear down your Spark clusters on OpenStack.

## Table of contents
- [Getting started](#getting-started)
  - [Get SparkNow](#get-sparknow)
  - [Install Packer and Terraform](#install-packer-and-terraform)
  - [Build SparkNow](#build-sparknow)
  - [Deploy a Spark cluster](#deploy-a-spark-cluster)
- [Access Spark UI and Jupyter](#access-spark-ui-and-jupyter)

## Getting started

### Install Packer and Terraform
SparkNow uses Packer (https://www.packer.io/) and Terraform (https://www.terraform.io/), to build
its OpenStack image and to provision the cluster. Please install both of them on your local machine,
following the instruction on their websites.

### Get SparkNow
To get SparkNow just clone this repository.

```bash
git clone https://github.com/mcapuccini/SparkNow.git
```

### Build SparkNow
To build SparkNow on your OpenStack tenancy, first export the following environment variables on your local
machine.

```bash
export SPARK_DOWNLOAD_URL="http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.6.tgz"
# you can change the download URL if you need another Spark version

export PACKER_IMAGE_NAME="SparkNow_spark-1.6.0-hadoop2.6"
export PACKER_SOURCE_IMAGE_NAME="Ubuntu 14.04" #this may be different in your OpenStack tenancy
export PACKER_NETWORK="" # your OpenStack tenancy private network id
export PACKER_FLAVOUR="" # the instance flavor that you want to use to build SparkNow
export PACKER_AVAILABILITY_ZONE="" # an availability zone name in your OpenStack tenancy
export PACKER_FLOATING_IP_POOL="" # a floating IP pool in your OpenStack tenancy
```

Then, access your OpenStack tenancy through the web interface, download the OpenStack RC file
(Compute > Access & Security > API Access & Security > Download OpenStack RC FILE) and source it.

```bash
source someproject-openrc.sh # you will be asked to type your password
```

Finally, locate in the SparkNow directory, and run Packer to build the SparkNow image.

```bash
cd SparkNow/
packer build packer/build.json # you will be asked to type your password
```

If everything goes well, you will see the new image in the OpenStack web interface (Compute > Images).

### Deploy a Spark cluster
First create a `conf.tfvars` file, specifying some properties for the Spark cluster that you aim to deploy.

**conf.tfvars**

```
keypair_name = "your-keypair"
cluster_prefix = "SparkNow"
floating_ip_pool = ""
SparkNow_image_name = "SparkNow_spark-1.6.0-hadoop2.6"
master_flavor_name = ""
worker_flavor_name = ""
worker_count = "3"
worker_volume_size = "20"
master_volume_size = "10"
```

>
- *keypair_name*: name of a key pair that you previously created, using the OpenStack web interface
(Compute > Access & Security > Key Pairs).
- *cluster_prefix*: prefix for the resources that will be created in your OpenStack tenancy
- *floating_ip_pool*: a floating IP pool in your OpenStack tenancy
- *SparkNow_image_name*: the name of the SparkNow image that you built in the previous step
- *master_flavor_name*: the Spark master instance flavor
- *worker_flavor_name*: the Spark worker instance flavor
- *worker_count*: number of Spark workers to deploy
- *worker_volume_size*: the size of the worker instance volume in Gb
- *master_volume_size*: the size of the master instance volume in Gb

Run Terraform to deploy a Spark cluster (assuming you already sourced the OpenStack RC file).

```bash
cd SparkNow/terraform
terraform get # download terraform modules (required only the first time you deploy)
terraform apply -var-file=conf.tfvars # deploy the cluster
```

If everity goes well, something like the following will be printed:

```bash
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
```

## Access Spark UI and Jupyter
The best way to access the UIs is through ssh port forwarding. We discourage to open the ports in the security group.

First, figure out the Spark Master floating IP address, running the following command.

```bash
# assuming you are located into SparkNow/terraform
terraform show | grep floating_ip
```

Then forward the UIs ports using ssh
```bash
ssh -N -f -L localhost:8080:localhost:8080 ubuntu@<master-floating-ip>
ssh -N -f -L localhost:8888:localhost:8888 ubuntu@<master-floating-ip>
```

If everything went well, you should be able to access the Spark UI, and the Jupyter notebook from your browser at the
following addresses.

- Spark UI: [http://localhost:8080](http://localhost:8080)
- Jupyter: [http://localhost:8888](http://localhost:8888)
