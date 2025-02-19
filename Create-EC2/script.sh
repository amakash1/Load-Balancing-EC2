#!/bin/bash

# Set AWS region and AMI ID (Amazon Linux 2)
AWS_REGION="us-east-1"
AMI_ID="ami-053a45fff0a704a47"  # Amazon Linux 2 AMI for us-east-1
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_NAME="EC2-HTTP-Access-Default"

# Create Security Group allowing HTTP traffic
echo "🔹 Creating Security Group..."
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "$SECURITY_GROUP_NAME" \
    --description "Allow HTTP traffic" --region "$AWS_REGION" --query 'GroupId' --output text)

# Allow inbound HTTP traffic (port 80)
aws ec2 authorize-security-group-ingress --group-id "$SECURITY_GROUP_ID" \
    --protocol tcp --port 80 --cidr 0.0.0.0/0 --region "$AWS_REGION"

echo "Security Group Created: $SECURITY_GROUP_ID"

# User data for Instance 1 (MetaData Page 1)
USER_DATA_1='#!/bin/bash
yum update -y
yum install -y nginx
echo "<h1>Welcome to EC2 Instance 1</h1>" > /usr/share/nginx/html/index.html
systemctl start nginx
systemctl enable nginx
'

# User data for Instance 2 (MetaData Page 2)
USER_DATA_2='#!/bin/bash
yum update -y
yum install -y nginx
echo "<h1>Welcome to EC2 Instance 2</h1>" > /usr/share/nginx/html/index.html
systemctl start nginx
systemctl enable nginx
'

# Launch EC2 Instance 1
echo " Launching EC2 Instance 1..."
INSTANCE_1_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --count 1 --instance-type "$INSTANCE_TYPE" \
     --security-group-ids "$SECURITY_GROUP_ID" \
    --user-data "$USER_DATA_1" --region "$AWS_REGION" --query 'Instances[0].InstanceId' --output text)

# Launch EC2 Instance 2
echo " Launching EC2 Instance 2..."
INSTANCE_2_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --count 1 --instance-type "$INSTANCE_TYPE" \
     --security-group-ids "$SECURITY_GROUP_ID" \
    --user-data "$USER_DATA_2" --region "$AWS_REGION" --query 'Instances[0].InstanceId' --output text)

echo " Waiting for instances to initialize..."
sleep 20  # Allow some time for instances to boot up

# Get Public IPs
IP_1=$(aws ec2 describe-instances --instance-ids "$INSTANCE_1_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
IP_2=$(aws ec2 describe-instances --instance-ids "$INSTANCE_2_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

echo " EC2 Instances Launched!"
echo " Instance 1 Public IP: http://$IP_1"
echo " Instance 2 Public IP: http://$IP_2"

