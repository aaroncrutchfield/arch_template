#!/bin/bash

echo "Creating new Cubit..."
echo "Please give your new cubit a name:"
read CUBIT_NAME
mason make flutter_bloc_feature \
    --name $CUBIT_NAME \
    --type cubit \
    --style equatable \
    --output-dir=lib/features 