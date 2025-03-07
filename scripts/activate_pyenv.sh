#!/bin/bash

CONFIG_FILE="config.ini"
PYENV_NAME=$(grep -E '^python_virtual_env=' "$CONFIG_FILE" | cut -d '=' -f 2)

echo -e "\033[1m\033[33mNOTE:\033[0m Consider running \033[38;5;2mmake create-pyenv\033[0m if you've made changes in requirements.txt"
echo "========================================================================="
echo "Step 1: Initializing Pyenv"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo -e "Pyenv Initialized \xE2\x9C\x94"

echo "========================================================================="
echo "Step 2: Activating Virtual Environment $PYENV_NAME"
pyenv activate "$PYENV_NAME"

# Check if activation was successful
if [ $? -ne 0 ]; then
    echo "Failed to activate virtual environment '$PYENV_NAME'."
    exit 1
fi

echo "========================================================================="
echo -e "\033[1m\033[38;5;2mVirtual environment $PYENV_NAME is activated and ready for use. \xE2\x9C\x94\033[0m"
echo -e "\xE2\x9A\x99 Set up your IDE to start using the python interpreter"
echo -e "Interpreter can be set as \033[38;5;2m~/.pyenv/versions/${PYENV_NAME}/bin/python\033[0m"
echo -e "\xE2\x9A\xA0 Make sure to run \033[38;5;2mmake deactivate-pyenv\033[0m  to shutdown virtual environment after use."
echo "========================================================================="