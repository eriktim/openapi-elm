# OpenAPI Elm

Guide on the usage and background of using the OpenAPI Generator with Elm.

## Build GitBook

```
./build.sh
```

## Run example

```bash
cd example
java -jar /path/to/openapi-generator-cli.jar generate -g elm -i swapi.yaml -o generated
elm reactor # visit http://localhost:8000/src/Main.elm
```
