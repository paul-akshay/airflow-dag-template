# Define variables
SCRIPTS_DIR := scripts
CONFIG_FILE := config.ini

AIRFLOW_DOCKER_IMAGE_NAME := $(shell grep -E '^airflow_docker_image=' ${CONFIG_FILE} | cut -d '=' -f 2)

.PHONY: help check-env check build-docker start stop create-pyenv activate-pyenv deactivate-pyenv

help:
	$(shell chmod +x ${SCRIPTS_DIR}/help.sh)
	${SCRIPTS_DIR}/help.sh


check-env:
	$(shell chmod +x ${SCRIPTS_DIR}/validate_env.sh)
	${SCRIPTS_DIR}/validate_env.sh

check:
	$(shell chmod +x ${SCRIPTS_DIR}/validate_build.sh)
	${SCRIPTS_DIR}/validate_build.sh


build:
	docker build -t $(AIRFLOW_DOCKER_IMAGE_NAME) ./

start:
	@echo "==============================================================="
	@echo -e "Building and starting Required Docker containers. \xE2\x8F\xB3"
	@docker-compose -f ./docker-compose.yaml -p "$(AIRFLOW_DOCKER_IMAGE_NAME)" up -d
	@echo "\xE2\x98\x80 Airflow Started at \033[38;5;2mlocalhost:8080\033[0m"
	@echo "\xE2\x8C\xA8 Login with credentials \033[38;5;2mairflow:airflow\033[0m"
	@echo "Logs can be found under \033[38;5;2airflow-studio/logs\033[0m "
	@echo " "
	@echo "==============================================================="

stop:
	@echo "Shutting down Docker containers. \xE2\x8F\xB3"
	@echo "Forceful termination will be made after 60 seconds"
	@docker-compose -f ./docker-compose.yaml -p $(AIRFLOW_DOCKER_IMAGE_NAME) down -v --timeout 60


create-pyenv:
	$(shell chmod +x ${SCRIPTS_DIR}/create_pyenv.sh)
	${SCRIPTS_DIR}/create_pyenv.sh

activate-pyenv:
	$(shell chmod +x ${SCRIPTS_DIR}/activate_pyenv.sh)
	${SCRIPTS_DIR}/activate_pyenv.sh

deactivate-pyenv:
	$(shell chmod +x ${SCRIPTS_DIR}/deactivate_pyenv.sh)
	${SCRIPTS_DIR}/deactivate_pyenv.sh