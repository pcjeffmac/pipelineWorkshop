# pipelineWorkshop

These files are used as helper scripts, to ease the creation of the bastion for the workshop.
The focus of the workshop will be on AWS-EKS, but this can also be done in Azure.

I have also provided a cheetsheet for the necessary gitHub and Dynatrace credentils used during the workshop.
```creds.json```

Below are instructions for using the AWS CLI on your workstation to provison an ubuntu virtual machine on AWS (EC2). This bastion host will then be used to run the scripts to provision the cluster and application setup.

# Initialize AWS CLI on your workstation

Make sure you have the AWS CLI installed on your workstation.
See [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

Run this command to configure the AWS CLI 
```
aws configure
```

At the prompt, 
* enter your AWS Access Key ID
* enter your AWS Secret Access Key ID
* enter Default region name example us-east-1
* enter Default output format, enter json

See [this article](https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/) for For help access keys

When complete, run this command ```aws iam list-access-keys``` to verify your configuration.

Output should be similar to this,

```
{
    "AccessKeyMetadata": [
        {
            "UserName": "_CLI",
            "Status": "Active",
            "CreateDate": "2019-04-18T18:22:31Z",
            "AccessKeyId": ""
        }
    ]
}
```

Now you are ready to provision the bastion host in AWS.

# Provision bastion host using AWS CLI

These instructions assume you have an AWS account and have the AWS CLI installed and configured locally from the above step.

These commands work on Mac and Linux.  You will need to adjust for running on Windows.

See [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) for local CLI installation and configuration.

Download Scripts,

Edit these lines in ```bastion.sh```, these are just place holders.

```
export CLUSTER_REGION=<example us-east-1>
export RESOURCE_PREFIX=<example your last name>
```
Your script should look something like this.

```
export CLUSTER_REGION=us-east-1
export RESOURCE_PREFIX=lastname
export AMI_ID=ami-07b4156579ea1d7ba
```

Now we can execute the prepared script to create the bastion.
```
./bastion.sh
```
I have simply created this script to automate the process of creating the EC2 instance.
This script will create a (Ubuntu Server 16.04 LTS (HVM), SSD Volume Type) EC2 host.

You may need to get the correct the AMI for your region.

### Key Pair

This script will also create a key pair and save the key pair to your local machine.
You will need this .pem file to ssh into your ec2 instance.

The .pem file will be named ```<example your last name>_ssh.pem```

The ssh_key is the name of your key pair,
See [Amazon EC2 Key Pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

## Run Script to provision resources 

On your laptop, run this commands to create the bastion host with security group that allows ssh access.
The script needs execute permissions ```chmod +x bastion.sh```

Now execute the script.
```
./bastion.sh
```
Validate the bastion has been created in EC2 console.

<img src="images/ec2-image.png" width="300"/>


# Connect and Prepare the bastion host 

## 1. SSH to the bastion host 

From the aws web console, get the SSH command to connect to the bastion host. For example:
```
ssh -i "<your pem file>.pem" ubuntu@<your host>.compute.amazonaws.com
```

REFERENCE: [aws docs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html?icmpid=docs_ec2_console)

## 2. Initialize AWS CLI on the bastion

Within the bastion host, run these commands to install the AWS CLI 
```
sudo apt update
sudo apt install awscli --yes
```

Run this command to configure the AWS CLI 
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
# Now we are ready to proceed with the workshop.

# Delete the bastion

After the completion of the workshop you can delete the AWS-EC2 instance.
This will also delete the key pair created.

Edit these lines in ```removebastion.sh```,
```
export CLUSTER_REGION=<example us-east-1>
export RESOURCE_PREFIX=<example your last name>
```

Then simply run ```./removebastion.sh``` to delete the AWS-EC2 instnace.

@jyarbrough
