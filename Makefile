.PHONY: run

DOCKER_COMPOSE ?= docker-compose
DOCKER_USER ?= "$(shell id -u):$(shell id -g)"
ENV ?= "dev"

run:
	@make -s up

up:
	@ENV=$(ENV) DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) up -d --build --force-recreate

up-prod:
	@ENV=$(ENV) DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) -f compose.prod.yml up -d --build --force-recreate

down:
	@ENV=$(ENV) DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) down

install:
	docker-compose exec frankenphp composer install
	docker-compose exec frankenphp bin/console sylius:install -s default -n
	make yarn-install
	make update-channel-url

clean:
	@ENV=$(ENV) DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) down -v

franken:
	@ENV=$(ENV) DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) exec frankenphp bash

cc:
	docker-compose exec frankenphp bin/console cache:clear

yarn-install:
	docker-compose --profile tools run --user root --rm nodejs "yarn install && yarn encore dev"

yarn-shell:
	@ENV=$(ENV) DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) --profile tools run --rm -i nodejs sh

node-watch:
	@ENV=$(ENV) DOCKER_USER=$(DOCKER_USER) $(DOCKER_COMPOSE) --profile tools run --rm -i nodejs "npm run watch"

update-channel-url:
	@read -p "Entrez le nouveau hostname: " hostname; \
    docker-compose exec frankenphp bin/console doctrine:query:sql \
    "UPDATE sylius_channel SET hostname = '$${hostname}' LIMIT 1"
