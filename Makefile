.DEFAULT_GOAL := help
.PHONY: help up down reset logs psql

COMPOSE := docker compose

help:  ## List the available targets
	@grep -hE '^[a-z_-]+:.*?## ' $(MAKEFILE_LIST) \
	  | awk -F':.*?## ' '{printf "  %-8s %s\n", $$1, $$2}'

up:  ## Start the database in the background and wait until it is healthy
	$(COMPOSE) up -d --wait

down:  ## Stop the database, keeping its data
	$(COMPOSE) down

reset:  ## Wipe the volume and rebuild the database from db/init
	$(COMPOSE) down -v
	$(COMPOSE) up -d --wait

logs:  ## Follow the database log
	$(COMPOSE) logs -f postgres

psql:  ## Open an interactive psql session
	$(COMPOSE) exec postgres sh -c 'exec psql -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"'
