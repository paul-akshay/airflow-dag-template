#!/bin/bash

# Path to the activation script
PYENV_ACTIVATION_SCRIPT="./scripts/activate_pyenv.sh"

# Run the activation script
echo "Running pyenv activation script..."
if ! source "$PYENV_ACTIVATION_SCRIPT"; then
    echo "Failed to activate pyenv virtual environment. Exiting."
    exit 1
fi

echo "Step 3: Installing build dependencies"
echo "Installing required modules for linting and testing..."
pip install -q -r requirements.txt

# Check if installation of test dependencies was successful
if [ $? -ne 0 ]; then
    echo -e "\033[1m\033[31mInstallation of test dependencies failed.\033[0m"
    exit 1
else
    echo -e "\033[1m\033[32mTest dependencies installed successfully. \xE2\x9C\x94\033[0m"
fi

BUILD_CHECKS_SCRIPT_PATH="./scripts/run_checks.sh"
chmod +x "$BUILD_CHECKS_SCRIPT_PATH"
# Run the checks script
"$BUILD_CHECKS_SCRIPT_PATH"

echo "========================================================================="
echo -e "\xE2\x9A\xA0 Remember to deactivate the virtual environment after use with \033[38;5;2mmake deactivate-pyenv\033[0m."
