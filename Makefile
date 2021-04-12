.DEFAULT_GOAL := help

CERTBOT_COMMAND = docker run \
  -v $(PWD)/volumes/certbot/conf:/etc/letsencrypt \
  -v $(PWD)/volumes/certbot/www:/var/www/certbot \
  -p "80:80" --rm \
  certbot/certbot \
  certonly \
  --test-cert \
  --standalone \
  --non-interactive --agree-tos --expand \
  --renew-with-new-domains \
  --rsa-key-size 4096 \
  --cert-name $$(cat config.yaml | yq -r '.letsencrypt.certname') \
  -m $$(cat config.yaml | yq -r '.letsencrypt.email') \
  -d $$(cat config.yaml | yq -r '.letsencrypt.hosts | join(",")')

config:  ## Generate all configuration files
	find ./ -name '*.j2' | sed 's/\.[^.]*$$//' | awk '{print "jinja2 --format yaml " $$1 ".j2 config.yaml > " $$1}' | sh

certbot-kickstart:  ## Kickstart the certbot configuration. create initial certs and configs so nginx can start
	rm -rf ./volumes/certbot
	@echo "Executing certbot against LetsEncrypt Prod"
	@echo $(CERTBOT_COMMAND)
	@$(CERTBOT_COMMAND)

certbot-kickstart-test:  ## Test the certbot configuration using letsencrypt staging
	@echo "Executing certbot against LetsEncrypt Staging"
	@echo $(CERTBOT_COMMAND) --test-cert
	@$(CERTBOT_COMMAND) --test-cert

clean:  ## Remove generated files
	@# Delete all jinja2-generated files
	find ./ -name '*.j2' | sed 's/\.[^.]*$$//' | xargs rm -f


help: ## Print list of Makefile targets
	@# Taken from https://github.com/spf13/hugo/blob/master/Makefile
	@grep --with-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  cut -d ":" -f2- | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort
