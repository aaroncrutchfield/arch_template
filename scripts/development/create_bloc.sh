#!/bin/bash

echo "Creating new Bloc..."
echo "Please give your new bloc a name:"
read BLOC_NAME
mason make flutter_bloc_feature \
    --name $BLOC_NAME \
    --type bloc \
    --style equatable \
    --output-dir=lib/features 