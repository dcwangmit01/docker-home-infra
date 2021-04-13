.DEFAULT_GOAL := help

create:
	cat parameters.yaml | yq . > parameters.json
	AWS_DEFAULT_PROFILE=default AWS_DEFAULT_REGION=us-west-2 aws \
	cloudformation create-stack \
	  --stack-name $(USER)-hackmd-stack \
	  --template-body file:///$(PWD)/infra-cloudformation.yaml \
	  --parameters file:///$(PWD)/parameters.json || true
	rm -f parameters.json

update:
	cat parameters.yaml | yq . > parameters.json
	AWS_DEFAULT_PROFILE=default AWS_DEFAULT_REGION=us-west-2 aws \
	cloudformation update-stack \
	  --stack-name $(USER)-hackmd-stack \
	  --template-body file:///$(PWD)/infra-cloudformation.yaml \
	  --parameters file:///$(PWD)/parameters.json || true
	rm -f parameters.json

delete:
	cat parameters.yaml | yq . > parameters.json
	AWS_DEFAULT_PROFILE=default AWS_DEFAULT_REGION=us-west-2 aws \
	cloudformation delete-stack \
	  --stack-name $(USER)-hackmd-stack
	rm -f parameters.json

help: ## Print list of Makefile targets
	@# Taken from https://github.com/spf13/hugo/blob/master/Makefile
	@grep --with-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  cut -d ":" -f2- | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort
