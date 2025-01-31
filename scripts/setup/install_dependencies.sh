#!/bin/bash

echo "Installing dependencies..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
\curl -sSL https://get.rvm.io | bash -s stable
rvm install 3.1.0
rvm use 3.1.0 