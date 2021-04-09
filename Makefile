.DEFAULT_GOAL := help

config:  ## Generate all configuration files
	jinja2 --format yaml docker-compose.yaml.j2 config.yaml > docker-compose.yaml
	jinja2 --format yaml conf/nginx_sites.conf.j2 config.yaml > conf/nginx_sites.conf
	jinja2 --format yaml conf/authorized_keys.j2 config.yaml > conf/authorized_keys
	jinja2 --format yaml conf/htpasswd.j2 config.yaml > conf/htpasswd

clean:  ## Remove intermediate files
	rm -f conf/authorized_keys
	rm -f conf/htpasswd
	rm -f conf/nginx_sites.conf
	rm -f docker-compose.yaml


help: ## Print list of Makefile targets
	@# Taken from https://github.com/spf13/hugo/blob/master/Makefile
	@grep --with-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  cut -d ":" -f2- | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort
