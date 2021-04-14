## Instructions

```
# Copy the example parameters file
cp parameters.yaml.example parameters.yaml

# Edit parameters file
emacs parameters.yaml

# Launch the cloud formation stack
make create-stack

# Update the cloud formation stack
make update-stack

# Connect to the instance via AWS Session Manager
AWS_DEFAULT_REGION=us-west-2 aws ssm start-session --target <aws-instance-id>
```