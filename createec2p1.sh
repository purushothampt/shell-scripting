aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" | jq --query "Instances[*].[PrivateIpAddress]" --output text

