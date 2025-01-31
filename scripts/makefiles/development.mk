## =================== Development Tools =================== ##
# Template features:
# - Build flavors
# - Internationalization support
# - Bloc pattern
# - Very Good Analysis
# https://cli.vgv.dev/docs/templates/core
# https://cli.vgv.dev/docs/templates/flutter_pkg
# https://brickhub.dev/bricks/flutter_bloc_feature

.PHONY: app package bloc cubit

app:
	@scripts/development/create_app.sh

package:
	@scripts/development/create_package.sh

bloc:
	@scripts/development/create_bloc.sh

cubit:
	@scripts/development/create_cubit.sh 