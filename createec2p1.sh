aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" --query "Instances[*].[PrivateIpAddress]" --output text

