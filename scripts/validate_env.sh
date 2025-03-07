#!/bin/bash

validate_prereqs() {
   echo " "
   echo "======================================================================================="
   echo "Validating Prerequisites for Dev Environment set up and starting Airflow in local"
   echo "======================================================================================="
   echo " "
   docker -v >/dev/null 2>&1
   if [ $? -ne 0 ]; then
      echo -e "'FAIL | docker' is not installed or not runnable without sudo. \xE2\x9D\x8C"
   else
      echo -e "SUCCESS | Docker is Installed. \xE2\x9C\x94"
   fi

   docker-compose -v >/dev/null 2>&1
   if [ $? -ne 0 ]; then
      echo -e "'FAIL | docker-compose' is not installed. \xE2\x9D\x8C"
   else
      echo -e "SUCCESS | Docker compose is Installed. \xE2\x9C\x94"
   fi

   python3 --version >/dev/null 2>&1
   if [ $? -ne 0 ]; then
      echo -e "FAIL | Python3 is not installed. \xE2\x9D\x8C"
   else
      echo -e "SUCCESS | Python3 is Installed \xE2\x9C\x94"
   fi

   python_version=$(python3 --version 2>&1 | cut -d " " -f 2)
   echo -e "Python version Found: ($python_version)"

   pip3 --version >/dev/null 2>&1
   if [ $? -ne 0 ]; then
      echo -e "FAIL | Pip3 is not installed. \xE2\x9D\x8C"
   else
      echo -e "SUCCESS | Pip3 is Installed. \xE2\x9C\x94"
   fi

  if ! command -v pyenv &>/dev/null; then
    echo -e "FAIL | pyenv is not installed. \xE2\x9D\x8C To install : brew install pyenv"
  else
    echo -e "SUCCESS | pyenv is installed. \xE2\x9C\x94"
  fi

  if ! command -v pyenv-virtualenv &>/dev/null; then
    echo -e "FAIL | pyenv-virtualenv is not installed. \xE2\x9D\x8C To install : brew install pyenv-virtualenv"
  else
    echo -e "SUCCESS | pyenv-virtualenv is installed. \xE2\x9C\x94"
  fi
}

validate_prereqs