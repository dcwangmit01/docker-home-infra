.DEFAULT_GOAL := help

STACK_NAME=$(USER)-hackmd-stack

deps:  ## Install dependencies
	@test -x $(GOPATH)/bin/cfn-format || \
		(cd /tmp && GO111MODULE=on go get github.com/awslabs/aws-cloudformation-template-formatter/cmd/cfn-format)
	@if ! which cfn-lint 2>&1 > /dev/null; then \
	  pip install cfn-lint; \
	fi
	@if ! aws plugins 2>&1 | grep ssm > /dev/null; then \
		(cd /tmp && \
		 curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
	         sudo dpkg -i session-manager-plugin.deb); \
	fi

format:  ## Format files
	@# yq is not good to format CloudFormation YAML templates
	$(GOPATH)/bin/cfn-format -w infra-cloudformation.yaml
	@echo >> infra-cloudformation.yaml
	cfn-lint infra-cloudformation.yaml
	@set -e; \
	TEMP_FILE=$$(mktemp); \
	for JSON in $$(find . -name \*json); do \
		echo "==> Formatting $${JSON}."; \
		cat $${JSON} | jq -r > $${TEMP_FILE}; \
		mv $${TEMP_FILE} $${JSON}; \
	done


create-stack:  ## Create stack
	cat parameters.yaml | yq . > parameters.json
	AWS_DEFAULT_PROFILE=default AWS_DEFAULT_REGION=us-west-2 aws \
	cloudformation create-stack \
	  --stack-name $(STACK_NAME) \
	  --template-body file:///$(PWD)/infra-cloudformation.yaml \
	  --parameters file:///$(PWD)/parameters.json \
	  --capabilities CAPABILITY_NAMED_IAM || true
	rm -f parameters.json
	@echo "Connect to instance console with:"
	@echo "  AWS_DEFAULT_REGION=us-west-2 aws ssm start-session --target <aws-instance-id>"

update-stack:  ## Update stack
	cat parameters.yaml | yq . > parameters.json
	AWS_DEFAULT_PROFILE=default AWS_DEFAULT_REGION=us-west-2 aws \
	cloudformation update-stack \
	  --stack-name $(STACK_NAME) \
	  --template-body file:///$(PWD)/infra-cloudformation.yaml \
	  --parameters file:///$(PWD)/parameters.json \
	  --capabilities CAPABILITY_NAMED_IAM || true
	rm -f parameters.json
	@echo "Connect to instance console with:"
	@echo "  AWS_DEFAULT_REGION=us-west-2 aws ssm start-session --target <aws-instance-id>"

delete-stack:  ## Delete stack
	cat parameters.yaml | yq . > parameters.json
	AWS_DEFAULT_PROFILE=default AWS_DEFAULT_REGION=us-west-2 aws \
	cloudformation delete-stack \
	  --stack-name $(STACK_NAME)
	rm -f parameters.json
	@echo "Connect to instance console with:"
	@echo "  AWS_DEFAULT_REGION=us-west-2 aws ssm start-session --target <aws-instance-id>"

help: ## Print list of Makefile targets
	@# Taken from https://github.com/spf13/hugo/blob/master/Makefile
	@grep --with-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  cut -d ":" -f2- | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort
