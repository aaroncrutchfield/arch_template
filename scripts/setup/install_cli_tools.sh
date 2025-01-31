#!/bin/bash

echo "Installing CLI tools..."
dart pub global activate very_good_cli
dart pub global activate flutterfire_cli
dart pub global activate mason_cli
mason init
mason add flutter_bloc_feature 