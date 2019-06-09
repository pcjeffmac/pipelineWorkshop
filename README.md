# pipelineWorkshop

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
