#!/bin/bash

# Function to display help message
display_help() {
   echo " "
   echo "=================================================================================================================="
   echo -e "\033[1;33m                                    Airflow DAG Template Demonstration\033[0m"
   echo "=================================================================================================================="
   echo -e "\033[1;37m          Syntax: \033[1;36mmake <command>\033[0m"
   echo "=================================================================================================================="
   echo -e "\033[1;36mhelp\033[0m                    Print CLI help"
   echo -e "\033[1;36mcheck\033[0m                   Run CI Checks in local. Verify code quality: Lint (pylint) and test (pytest) DAGs"
   echo "------------------------------------------------------------------------------------------------------------------"
   echo -e "\033[1;36mbuild\033[0m                   Build Docker Image in Dev Machine"
   echo -e "\033[1;36mstart\033[0m                   Start Airflow local environment. (LocalExecutor, Using postgres DB)"
   echo -e "\033[1;36mstop\033[0m                    Stop Airflow local environment. (LocalExecutor, Using postgres DB)"
   echo "------------------------------------------------------------------------------------------------------------------"
   echo -e "\033[1;36mcheck-env\033[0m               Validate pre-reqs installed in local (docker, docker-compose, python3, pip3)"
   echo -e "\033[1;36mcreate-pyenv\033[0m            Create and activates the virtual environment to provide the Python Interpreter for IDE"
   echo -e "\033[1;36mactivate-pyenv\033[0m          Activate the virtual environment already created previously"
   echo -e "\033[1;36mdeactivate-pyenv\033[0m        Deactivate the virtual environment created above"
   echo "=================================================================================================================="
   echo " "

}

display_help
