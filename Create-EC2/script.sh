#!/bin/bash

AWS_REGION="us-east-1"
AMI_ID="ami-053a45fff0a704a47"  
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP_NAME="EC2-HTTP-Access-Default"

echo "🔹 Creating Security Group..."
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "$SECURITY_GROUP_NAME" \
    --description "Allow HTTP traffic" --region "$AWS_REGION" --query 'GroupId' --output text)

aws ec2 authorize-security-group-ingress --group-id "$SECURITY_GROUP_ID" \
    --protocol tcp --port 80 --cidr 0.0.0.0/0 --region "$AWS_REGION"

echo "Security Group Created: $SECURITY_GROUP_ID"

USER_DATA_1='#!/bin/bash
yum update -y
yum install -y nginx
echo "<h1>Welcome to EC2 Instance 1</h1>" > /usr/share/nginx/html/index.html
systemctl start nginx
systemctl enable nginx
'

USER_DATA_2='#!/bin/bash
yum update -y
yum install -y nginx
echo "<h1>Welcome to EC2 Instance 2</h1>" > /usr/share/nginx/html/index.html
systemctl start nginx
systemctl enable nginx
'

echo " Launching EC2 Instance 1..."
INSTANCE_1_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --count 1 --instance-type "$INSTANCE_TYPE" \
     --security-group-ids "$SECURITY_GROUP_ID" \
    --user-data "$USER_DATA_1" --region "$AWS_REGION" --query 'Instances[0].InstanceId' --output text)


echo " Launching EC2 Instance 2..."
INSTANCE_2_ID=$(aws ec2 run-instances --image-id "$AMI_ID" --count 1 --instance-type "$INSTANCE_TYPE" \
     --security-group-ids "$SECURITY_GROUP_ID" \
    --user-data "$USER_DATA_2" --region "$AWS_REGION" --query 'Instances[0].InstanceId' --output text)

echo " Waiting for instances to initialize..."
sleep 20 


IP_1=$(aws ec2 describe-instances --instance-ids "$INSTANCE_1_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
IP_2=$(aws ec2 describe-instances --instance-ids "$INSTANCE_2_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

echo " EC2 Instances Launched!"
echo " Instance 1 Public IP: http://$IP_1"
echo " Instance 2 Public IP: http://$IP_2"

