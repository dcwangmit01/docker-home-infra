# docker-home-infra
Docker-compose home infrastructure

## What this is

This docker-compose file runs self-hosted infrastructure services including:

* Nginx w/ Certbot SSL reverse proxy
* Hackmd -> (Postgres + PlantUml)


## Create a configuration file

config.yaml

```yaml
letsencrypt:
  # not actually a wildcard, but a single cert file for all hosts
  certname: wildcard.domain.com
  email: you@domain.com
  # hosts need to match conf/nginx/sites-enabled/sites.conf.j2
  hosts:
    - s.domain.com
    - hackmd.domain.com
    - plantuml.domain.com
    - whatismyip.domain.com

nginx:
  domain: domain.com
  htpasswd:
  # optional list of '- "username:password_hashes"'
  # created by: "htpasswd -n <user>", then enter <password>

hackmd:
  # https://github.com/organizations/<REPLACE_ORG_NAME>/settings/applications
  # oauth callback is: https://hackmd.domain.com/auth/github/callback
  CMD_GITHUB_CLIENTID: <REPLACE>
  CMD_GITHUB_CLIENTSECRET: <REPLACE>

hackmd_postgres:
  POSTGRES_USER: codimd
  POSTGRES_PASSWORD: <REPLACE>
  POSTGRES_DB: codimd

oauth2proxy:
  # https://github.com/organizations/<REPLACE_ORG_NAME>/settings/applications
  # oauth2 callback is: https://server.domain.com/oauth2/callback

  # hackmd.domain.com
  hackmd:
    OAUTH2_PROXY_CLIENT_ID: <REPLACE>
    OAUTH2_PROXY_CLIENT_SECRET: <REPLACE>
    OAUTH2_PROXY_COOKIE_SECRET: <REPLACE>
    OAUTH2_PROXY_COOKIE_DOMAIN: hackmd.domain.com
    OAUTH2_PROXY_COOKIE_NAME: hackmd.domain.com
    OAUTH2_PROXY_PROVIDER: github
    OAUTH2_PROXY_HTTP_ADDRESS: 0.0.0.0:4180
    OAUTH2_PROXY_UPSTREAMS: http://nginx-hackmd-plantuml
    OAUTH2_PROXY_GITHUB_ORG: <REPLACE>
    OAUTH2_PROXY_GITHUB_TEAM: <REPLACE>
    OAUTH2_PROXY_EMAIL_DOMAINS: '*'

  # plantuml.domain.com
  plantuml:
    OAUTH2_PROXY_CLIENT_ID: <REPLACE>
    OAUTH2_PROXY_CLIENT_SECRET: <REPLACE>
    OAUTH2_PROXY_COOKIE_SECRET: <REPLACE>
    OAUTH2_PROXY_COOKIE_DOMAIN: plantuml.domain.com
    OAUTH2_PROXY_COOKIE_NAME: plantuml.domain.com
    OAUTH2_PROXY_PROVIDER: github
    OAUTH2_PROXY_HTTP_ADDRESS: 0.0.0.0:4180
    OAUTH2_PROXY_UPSTREAMS: http://plantuml:8080
    OAUTH2_PROXY_GITHUB_ORG: <REPLACE>
    OAUTH2_PROXY_GITHUB_TEAM: <REPLACE>
    OAUTH2_PROXY_EMAIL_DOMAINS: '*'
```

## Run it

```
make config
make certbot-kickstart-test
make certbot-kickstart

docker-compose up
```
