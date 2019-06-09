#!/bin/bash
# adjust these variables
export SSH_KEY=<your ssh aws key name>
export CLUSTER_REGION=<example us-east-1>
export RESOURCE_PREFIX=<example your last name>
export AMI_ID=ami-07b4156579ea1d7ba

# leave these values as they are
export AWS_HOST_NAME="$RESOURCE_PREFIX"-dt-kube-demo-bastion
export AWS_SECURITY_GROUP_NAME="$RESOURCE_PREFIX"-dt-kube-demo-bastion-group

#create default VPC
aws ec2 create-default-vpc

# create-security-group
aws ec2 create-security-group \
  --group-name $AWS_SECURITY_GROUP_NAME \
  --description "Used by dt-kube-demo bastion host"

# get the new security-group id
export AWS_SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$AWS_SECURITY_GROUP_NAME" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

sleep 10
# update create-security-group with inbound rule
aws ec2 authorize-security-group-ingress \
  --group-id "$AWS_SECURITY_GROUP_ID" \
  --protocol tcp \
  --port 22 \
  --cidr "0.0.0.0/0"

sleep 10
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
