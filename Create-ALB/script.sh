#!/bin/bash

# Set AWS region and parameters
AWS_REGION="us-east-1"
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)  # Get default VPC
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --query "SecurityGroups[?GroupName=='EC2-HTTP-Access'].GroupId" --output text)
SUBNET_IDS=$(aws ec2 describe-subnets --query "Subnets[0:2].SubnetId" --output text)  # Get first 2 subnets for ALB

# Get EC2 Instance IDs
INSTANCE_1_ID="i-01bab02dab5481c43"
INSTANCE_2_ID="i-0cf3bc3d01089b90b"

echo "🔹 Creating Target Group..."
TARGET_GROUP_ARN=$(aws elbv2 create-target-group --name my-target-group \
    --protocol HTTP --port 80 --vpc-id "$VPC_ID" --target-type instance \
    --query 'TargetGroups[0].TargetGroupArn' --output text)

# Register EC2 instances to Target Group
echo "🔹 Registering Instances to Target Group..."
aws elbv2 register-targets --target-group-arn "$TARGET_GROUP_ARN" \
    --targets "Id=$INSTANCE_1_ID" "Id=$INSTANCE_2_ID"

# Create ALB
echo " Creating Application Load Balancer..."
ALB_ARN=$(aws elbv2 create-load-balancer --name my-load-balancer \
    --subnets $SUBNET_IDS --security-groups "$SECURITY_GROUP_ID" --scheme internet-facing \
    --type application --query 'LoadBalancers[0].LoadBalancerArn' --output text)

# Create ALB Listener for HTTP (port 80)
echo " Creating ALB Listener for HTTP traffic..."
aws elbv2 create-listener --load-balancer-arn "$ALB_ARN" --protocol HTTP --port 80 \
    --default-actions Type=forward,TargetGroupArn="$TARGET_GROUP_ARN"

# Get ALB DNS Name
ALB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$ALB_ARN" --query "LoadBalancers[0].DNSName" --output text)

echo " ALB Setup Complete! Access it here: http://$ALB_DNS"
