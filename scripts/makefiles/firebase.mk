## =================== Firebase Configuration =================== ##
# https://firebase.google.com/docs/flutter/setup?platform=android#configure-firebase
# https://github.com/invertase/flutterfire_cli/issues/14
# https://codewithandrea.com/articles/flutter-flavors-for-firebase-apps/
# https://firebase.google.com/docs/projects/dev-workflows/general-best-practices#registering-app-variants

.PHONY: fb-config-dev fb-config-stg fb-config-prod fb-config-all fb-create-dev fb-create-stg fb-create-prod fb-create-all

# Configure Firebase
fb-config-dev:
	@scripts/firebase/configure.sh development

fb-config-stg:
	@scripts/firebase/configure.sh staging

fb-config-prod:
	@scripts/firebase/configure.sh production

fb-config-all:
	@scripts/firebase/configure.sh all

# Create Firebase projects
fb-create-dev:
	@scripts/firebase/create_project.sh development

fb-create-stg:
	@scripts/firebase/create_project.sh staging

fb-create-prod:
	@scripts/firebase/create_project.sh production

fb-create-all:
	@scripts/firebase/create_project.sh all 