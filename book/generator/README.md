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


## Generating files

The OpenAPI Generator normally generates a fully functional project in your language of choice.
However, this is not always perfect as you typically have set-up your own project.
Therefore, the generated Elm code only contains the required files and an `elm.json` for reference.

Hence, the generator can be used in either of two ways:

* Via an additional directory in `source_directories` (recommended)
* Using `.openapi-generator-ignore`