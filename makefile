# Include all makefiles
include scripts/makefiles/*.mk

.PHONY: help
help:
	@echo "Available commands:"
	@echo "Setup:"
	@echo "  make setup-cli        Install CLI tools"
	@echo "  make setup-deps       Install project dependencies"
	@echo ""
	@echo "Firebase Projects:"
	@echo "  make fb-create-dev    Create Firebase development project"
	@echo "  make fb-create-stg    Create Firebase staging project"
	@echo "  make fb-create-prod   Create Firebase production project"
	@echo "  make fb-create-all    Create all Firebase projects"
	@echo ""
	@echo "Firebase Config:"
	@echo "  make fb-config-dev    Configure Firebase for development"
	@echo "  make fb-config-stg    Configure Firebase for staging"
	@echo "  make fb-config-prod   Configure Firebase for production"
	@echo "  make fb-config-all    Configure Firebase for all environments"
	@echo ""
	@echo "Development:"
	@echo "  make app             Create a new app"
	@echo "  make package         Create a new package"
	@echo "  make bloc            Create a new bloc"
	@echo "  make cubit           Create a new cubit"

.DEFAULT_GOAL := help