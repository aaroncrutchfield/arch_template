# Makefile Scripts

This directory contains make targets for various development tasks. Use `make help` to see all available commands.

## Setup Commands
```bash
# Install required CLI tools (very_good_cli, flutterfire_cli, mason_cli)
make setup-cli

# Install project dependencies
make setup-deps

# Install and configure Fastlane
make setup-fastlane
```

## Firebase Commands

### Project Creation
Create new Firebase projects for each environment:
```bash
# Create individual environments
make fb-create-dev     # Creates development project
make fb-create-stg     # Creates staging project
make fb-create-prod    # Creates production project

# Create all environments at once
make fb-create-all     # Creates all projects
```

### Project Configuration
Configure Firebase for each environment:
```bash
# Configure individual environments
make fb-config-dev     # Configures development environment
make fb-config-stg     # Configures staging environment
make fb-config-prod    # Configures production environment

# Configure all environments at once
make fb-config-all     # Configures all environments
```

This will:
- Create firebase_options.dart files
- Set up bundle IDs for iOS/macOS
- Configure Android package names
- Place config files in the correct directories

## Development Commands
```bash
# Create a new app using very_good_cli
make app

# Create a new package in the packages directory
make package

# Create a new bloc in lib/features
make bloc

# Create a new cubit in lib/features
make cubit
```

## Directory Structure
```
scripts/
├── development/       # Scripts for creating apps/packages/blocs
├── firebase/         # Scripts for Firebase setup and config
├── makefiles/        # Make targets and documentation
└── setup/           # Installation and dependency scripts
```

## Adding New Commands
1. Create a new script in the appropriate directory
2. Add a new target to the corresponding .mk file
3. Update this README.md with usage instructions
4. Update the help text in the root Makefile
```
