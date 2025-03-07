#!/bin/bash

REQUIREMENTS_FILE="requirements.txt"
CONFIG_FILE="config.ini"

PYTHON_VERSION=$(grep -E '^python_version=' "$CONFIG_FILE" | cut -d '=' -f 2)
PYENV_NAME=$(grep -E '^python_virtual_env=' "$CONFIG_FILE" | cut -d '=' -f 2)

echo "========================================================================="
echo "Step 1: Installing Python version $PYTHON_VERSION"
if pyenv versions --bare | grep -q "$PYTHON_VERSION"; then
    echo -e "Python version $PYTHON_VERSION is already installed. \xE2\x9C\x94"
else
    pyenv install "$PYTHON_VERSION"
    echo -e "Python version $PYTHON_VERSION installed. \xE2\x9C\x94"

    if [ $? -ne 0 ]; then
        echo "Failed to install Python version $PYTHON_VERSION"
        exit 1
    fi
fi

echo "========================================================================="
echo "Step 2: Creating Virtual Environment $PYENV_NAME"
if pyenv virtualenvs | grep -q "$PYENV_NAME"; then
    echo -e "Virtual environment '$PYENV_NAME' already exists. \xE2\x9C\x94"
else
    pyenv virtualenv "$PYTHON_VERSION" "$PYENV_NAME"
    echo -e "Virtual environment '$PYENV_NAME' created. \xE2\x9C\x94"
    if [ $? -ne 0 ]; then
        echo "Failed to create virtual environment"
        exit 1
    fi
fi

echo "========================================================================="
echo "Step 3: Initializing Pyenv"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo -e "Pyenv Initialized \xE2\x9C\x94"

echo "========================================================================="
echo "Step 4: Activating Virtual Environment $PYENV_NAME"
pyenv activate "$PYENV_NAME"

# Check if activation was successful
if [ $? -ne 0 ]; then
    echo "Failed to activate virtual environment '$PYENV_NAME'."
    exit 1
fi

echo -e "Virtual environment '$PYENV_NAME' activated successfully \xE2\x9C\x94"

echo "========================================================================="
echo "Step 5: Installing dependencies to $PYENV_NAME from $REQUIREMENTS_FILE"
pip install --index-url=https://pypi.org/simple -r "$REQUIREMENTS_FILE"
if [ $? -ne 0 ]; then
    echo "Failed to install requirements from $REQUIREMENTS_FILE"
    exit 1
fi

echo "========================================================================="
echo -e "\033[1m\033[38;5;2mVirtual environment $PYENV_NAME is activated and ready for use. \xE2\x9C\x94\033[0m"
echo -e "\xE2\x9A\x99 Set up your IDE to start using the python interpreter"
echo -e "Interpreter can be set as \033[38;5;2m~/.pyenv/versions/${PYENV_NAME}/bin/python\033[0m"
echo -e "\xE2\x9A\xA0 Make sure to run \033[38;5;2mmake deactivate-pyenv\033[0m  to shutdown virtual environment after use."
echo "========================================================================="

