aws ec2 describe-instances  --filters "Name=tag-value,Values=workstation" --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text

