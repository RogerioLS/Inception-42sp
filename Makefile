DOCKER_COMPOSE_PATH := ./srcs/requirements/docker-compose.yml
DOCKER_RESTART_PATH := ./srcs/requirements/tools/reset_docker_env.sh
DOCKER_HELP_PATH := ./srcs/requirements/tools/help
COMPOSE := docker-compose -f
DATA_DIR := /home/roglopes/data
DATA_DIR_WORDPRESS := /home/roglopes/data/mariadb
DATA_DIR_MARIADB := /home/roglopes/data/wordpress
HOSTNAME := roglopes.42.fr

all: stop build up changehostname

up: checkdatadir
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) up -d

build: checkdatadir
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) build

start: checkdatadir
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) start

down:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) down

stop:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) stop

restart:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) restart

services:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) ps

containers:
	@ docker ps -a

logs:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) logs -f

startservice: checkdatadir
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) start $(word 2, $(MAKECMDGOALS))

downservice:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) down $(word 2, $(MAKECMDGOALS))

stopservice:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) stop $(word 2, $(MAKECMDGOALS))

restartservice:
	@ $(COMPOSE) $(DOCKER_COMPOSE_PATH) restart $(word 2, $(MAKECMDGOALS))

resetdocker:
	@ $(DOCKER_RESTART_PATH)

iterative:
	@ docker exec -it $(word 2, $(MAKECMDGOALS)) bash

checkdatadir:
	@ if [ ! -d "$(DATA_DIR)" ]; then \
        mkdir -p $(DATA_DIR); \
    fi

	@ if [ ! -d "$(DATA_DIR_WORDPRESS)" ]; then \
        mkdir -p $(DATA_DIR_WORDPRESS); \
    fi

	@ if [ ! -d "$(DATA_DIR_MARIADB)" ]; then \
        mkdir -p $(DATA_DIR_MARIADB); \
    fi

changehostname:
	@if [ "$$EUID" -ne 0 ]; then \
		echo "⚠️  Você precisa ser root para alterar o /etc/hosts. Pule essa etapa ou altere manualmente."; \
	else \
		sed -i -E 's/^127\.0\.0\.1\s+localhost\b.*/127.0.0.1 $(HOSTNAME)/' /etc/hosts; \
	fi

mariadb-login:
    @echo "Passo a passo para acessar o MariaDB no container:"
    @echo "1. Liste os containers em execução:"
    @echo "   docker ps"
    @echo "2. Encontre o CONTAINER ID ou NAMES do container MariaDB."
    @echo "3. Acesse o container com o comando:"
    @echo "   make iterative <ID container>
    @echo "4. Dentro do container, acesse o MariaDB CLI com o comando:"
    @echo "   mariadb -u rog_dev -p "
    @echo "5. Escolha o banco de dados com o comando:"
    @echo "   USE WordPress;"
	@echo "6. Ixibir as tabelas disponíveis com o comando:"
	@echo "   SHOW TABLES;"
    @echo "7. Execute suas queries SQL."
	@echo "   Exemplo: SELECT * FROM wp_users;"
    @echo "8. Para sair do MariaDB CLI, digite:"
    @echo "   quit"

wordpress-login:
	@echo "Passo a passo para acessar o WordPress no container:"
	@echo "1. Abra seu navegador e acesse: https://roglopes.42.fr/wp-admin"
	@echo "2. Use as credenciais padrão:"
	@echo "   Usuário: rogerio    "
	@echo "   Senha: 83!dsaA@3f   "

help:
	@ cat $(DOCKER_HELP_PATH)

.PHONY: up build start down stop restart services logs startservice startserviceiter downservice restartservice resetdocker execiterative checkdatadir changehostname mariadb-login help