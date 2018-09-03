config:
	jinja2 --format yaml docker-compose.yaml.j2 config.yaml > docker-compose.yaml
	jinja2 --format yaml conf/nginx_sites.conf.j2 config.yaml > conf/nginx_sites.conf
	jinja2 --format yaml conf/authorized_keys.j2 config.yaml > conf/authorized_keys
	jinja2 --format yaml conf/htpasswd.j2 config.yaml > conf/htpasswd
