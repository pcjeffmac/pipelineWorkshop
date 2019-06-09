# pipelineWorkshop

These files are used as helper scripts to ease the creation of the bastion for the workshop.
The focus of the workshop will be on AWS-EKS, but this can also be done on Azure.

Below are instructions for using the AWS CLI on your workstation to provison an ubuntu virtual machine on AWS (EC2). This bastion host will then be used to run the scripts to provision the cluster and application setup.

# Initialize aws CLI on your workstation

Make sure you have the AWS CLI installed on your workstation.
See [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

Run this command to configure the cli 
```
aws configure
```

At the prompt, 
* enter your AWS Access Key ID
* enter your AWS Secret Access Key ID
* enter Default region name example us-east-1
* enter Default output format, enter json

See [this article](https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/) for For help access keys

When complete, run this command ```aws iam list-access-keys``` to see verify your configuration.

# Provision bastion host using CLI

These instructions assume you have an AWS account and have the AWS CLI installed and configured locally from the above step.

These commands work on Mac and Linux.  You will need to adjust for running on Windows.

See [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) for local CLI installation and configuration.

Download Scripts,

We are going to execute the prepared script to create the bastion.
```
./bastion.sh
```
The script will run the same commands listed under the "Run CLI to provision resources" section.
I have simply created this script to automate the process.
This script will create a (Ubuntu Server 16.04 LTS (HVM), SSD Volume Type) EC2 host.

We may need to get the correct AMI for your region.


## 1. Run CLI to provision resources

On your laptop, run these commands to create the bastion host with security group that allows ssh access

```
# adjust these variables
export SSH_KEY=<your ssh aws key name>
export CLUSTER_REGION=<example us-west-2>
export RESOURCE_PREFIX=<example your last name>
# NOTE: The AMI ID may vary my region. This is the AMI for us-west-2 
export AMI_ID=ami-08692d171e3cf02d6

# leave these values as they are
export AWS_HOST_NAME="$RESOURCE_PREFIX"-dt-kube-demo-bastion
export AWS_SECURITY_GROUP_NAME="$RESOURCE_PREFIX"-dt-kube-demo-bastion-group

# create-security-group
aws ec2 create-security-group \
  --group-name $AWS_SECURITY_GROUP_NAME \
  --description "Used by dt-kube-demo bastion host"

# get the new security-group id
export AWS_SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$AWS_SECURITY_GROUP_NAME" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

# update create-security-group with inbound rule
aws ec2 authorize-security-group-ingress \
  --group-id "$AWS_SECURITY_GROUP_ID" \
  --protocol tcp \
  --port 22 \
  --cidr "0.0.0.0/0"

# provision the host
aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --count 1 \
  --security-group-ids "$AWS_SECURITY_GROUP_ID" \
  --instance-type t2.micro \
  --key-name $SSH_KEY  \
  --associate-public-ip-address \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$AWS_HOST_NAME}]" \
  --region $CLUSTER_REGION
```

## 2. Proceed to 'Connect and Prepare to bastion host' section below

# Connect and Prepare to bastion host 

## 1. SSH to the bastion host 

From the aws web console, get the SSH command to connect to the bastion host. For example:
```
ssh -i "<your pem file>.pem" ubuntu@<your host>.compute.amazonaws.com
```

REFERENCE: [aws docs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html?icmpid=docs_ec2_console)

## 2. Initialize aws CLI on the bastion

Within the bastion host, run these commands to install the aws CLI 
```
sudo apt update
sudo apt install awscli --yes
```

Run this command to configure the cli 
```
aws configure
```

At the prompt, 
* enter your AWS Access Key ID
* enter your AWS Secret Access Key ID
* enter Default region name example us-east-1
* enter Default output format, enter json

See [this article](https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/) for For help access keys

When complete, run this command ```aws ec2 describe-instances``` to see your VMs

## 3. Clone the Orders setup repo

Within the VM, run these commands to clone the setup repo.

```
git clone https://github.com/dt-kube-demo/setup-infra.git
cd setup-infra
```
