.PHONY: run

# Détection automatique de docker-compose vs docker compose
DOCKER_COMPOSE := $(shell command -v docker-compose >/dev/null 2>&1 && echo "docker-compose" || echo "docker compose")
DOCKER_USER ?= "$(shell id -u):$(shell id -g)"

run:
	@make -s up

up:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) up -d --build --force-recreate

up-prod:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) -f compose.prod.yml up -d --build --force-recreate

down:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) down

install:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) exec frankenphp composer install
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) exec frankenphp bin/console sylius:install -s default -n
	make yarn-install
	make update-channel-url

clean:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) down -v

franken:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) exec frankenphp bash

cc:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) exec frankenphp bin/console cache:clear

yarn-install:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) --profile tools run --user root --rm nodejs "yarn install && yarn encore dev"

yarn-shell:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) --profile tools run --rm -i nodejs sh

node-watch:
	@DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) --profile tools run --rm -i nodejs "npm run watch"

update-channel-url:
	@read -p "Entrez le nouveau hostname: " hostname; \
    DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) exec frankenphp bin/console doctrine:query:sql \
    "UPDATE sylius_channel SET hostname = '$${hostname}' LIMIT 1"
