#!/bin/bash

#Use on Local AWS CLI
read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -s -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
echo ""
read -p "Enter AWS Region (default: us-east-1): " AWS_REGION
AWS_REGION=${AWS_REGION:-us-east-1} 

read -p "Enter AWS Profile Name (default: default): " AWS_PROFILE
AWS_PROFILE=${AWS_PROFILE:-default} 


aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$AWS_PROFILE"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$AWS_PROFILE"
aws configure set region "$AWS_REGION" --profile "$AWS_PROFILE"
aws configure set output json --profile "$AWS_PROFILE"

echo "AWS CLI configured successfully for profile '$AWS_PROFILE'!"


echo "🔍 Verifying AWS credentials..."
aws sts get-caller-identity --profile "$AWS_PROFILE"

if [ $? -eq 0 ]; then
    echo " AWS CLI setup is successful!"
else
    echo " AWS CLI setup failed. Please check your credentials."
fi
