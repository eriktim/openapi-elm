#!/bin/bash

set -e

cd openapi-generator
mvn clean install
java -jar modules/openapi-generator-cli/target/openapi-generator-cli.jar generate -i ../openapi.yaml  -g elm -o ../test
cd ../test
elm make src/**/*.elm
