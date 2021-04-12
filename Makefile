.DEFAULT_GOAL := help

config:  ## Generate all configuration files
	find ./ -name '*.j2' | sed 's/\.[^.]*$$//' | awk '{print "jinja2 --format yaml " $$1 ".j2 config.yaml > " $$1}' | sh

certbot-kickstart:  ## Kickstart the certbot configuration. create initial certs and configs so nginx can start
	rm -rf ./volumes/certbot
	docker run \
	  -v $(PWD)/volumes/certbot/conf:/etc/letsencrypt \
	  -v $(PWD)/volumes/certbot/www:/var/www/certbot \
	  -p "80:80" --rm \
	  certbot/certbot \
	  certonly \
	  --standalone \
	  --non-interactive --agree-tos --expand \
	  --renew-with-new-domains \
	  --rsa-key-size 4096 \
	  --cert-name 'wildcard.davidwang.com' \
	  -m 'dcwangmit01@gmail.com' \
	  -d 's.davidwang.com' -d 'hackmd.davidwang.com' -d 'plantuml.davidwang.com' -d 'whatismyip.davidwang.com'

certbot-kickstart-test:  ## Test the certbot configuration using letsencrypt staging
	@# The key difference here is the presence of --test-cert
	docker run \
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
	  --cert-name 'wildcard.davidwang.com' \
	  -m 'dcwangmit01@gmail.com' \
	  -d 's.davidwang.com' -d 'hackmd.davidwang.com' -d 'plantuml.davidwang.com' -d 'whatismyip.davidwang.com'

clean:  ## Remove generated files
	@# Delete all jinja2-generated files
	find ./ -name '*.j2' | sed 's/\.[^.]*$$//' | xargs rm -f


help: ## Print list of Makefile targets
	@# Taken from https://github.com/spf13/hugo/blob/master/Makefile
	@grep --with-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  cut -d ":" -f2- | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort
