

PRIVATE_IP=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text)
aws ec2 describe-images --filters "Name=AMI name,Values=Centos-7-DevOps-Practice" | jq



