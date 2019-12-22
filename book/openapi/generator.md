Generator proj

[see](https://github.com/OpenAPITools/openapi-generator#1---installation)

* jar
* docker
* npm

```
npm install @openapitools/openapi-generator-cli -g
openapi-generator generate -g elm -i openapi.yaml -o /path/to/generated
elm-format --yes /path/to/generated # optionally
```