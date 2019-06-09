#!/bin/bash
# adjust these variables
export SSH_KEY=<your ssh aws key name>
export CLUSTER_REGION=<example us-east-1>
export RESOURCE_PREFIX=<example your last name>

# leave these values
export AWS_HOST_NAME="$RESOURCE_PREFIX"-dt-kube-demo-bastion
export AWS_SECURITY_GROUP_NAME="$RESOURCE_PREFIX"-dt-kube-demo-bastion-group

# get bastion host instance id
export AWS_INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$AWS_HOST_NAME" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)
# terminate instance
aws ec2 terminate-instances --instance-ids $AWS_INSTANCE_ID

sleep 30

# get the security-group id
export AWS_SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$AWS_SECURITY_GROUP_NAME" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

# delete the security group
aws ec2 delete-security-group --group-id $AWS_SECURITY_GROUP_ID
