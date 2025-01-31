## ======================= CLI TOOLS ======================== ##
## Very Good CLI		- https://pub.dev/packages/very_good_cli
## FlutterFire CLI		- https://pub.dev/packages/flutterfire_cli
## Mason CLI			- https://pub.dev/packages/mason_cli
## Bloc Feature Brick	- https://brickhub.dev/bricks/flutter_bloc_feature
## ========================================================== ##

.PHONY: setup-cli setup-deps setup-fastlane

setup-cli:
	@scripts/setup/install_cli_tools.sh

setup-deps:
	@scripts/setup/install_dependencies.sh

setup-fastlane:
	@scripts/setup/install_fastlane.sh 