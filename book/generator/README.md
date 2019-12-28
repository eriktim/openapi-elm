# Generator

There are [multiple ways](https://openapi-generator.tech/) to run the generator, e.g. using a jar, docker image or npm.

Here is an example on how to run the generator using npm:

```
npm install @openapitools/openapi-generator-cli -g
openapi-generator generate -g elm -i openapi.yaml -o /path/to/generated
elm-format --yes /path/to/generated # optional
```

## Generating files

The OpenAPI Generator normally generates a fully functional project in your language of choice.
However, this is not always perfect as you typically have set-up your own project.
Therefore, the generated Elm code only contains the required files and an `elm.json` for reference.

Hence, the generator can be used in either of the two following ways.
In either case I advice not to put any generated code under version control.

### Modify `elm.json`

Generate your Elm code in a sub-directory of your Elm project.
Add the path to the `source_directories` of your `elm.json`.
This is the recommended approach.

Example:

```bash
openapi-generator -g elm -i openapi.yaml -o generated
edit elm.json # add `generated/src` to `source_directories`
elm make src/Main.elm
```

### Add `.openapi-generator-ignore`

When you do not have any project yet, you can use the output of the generator as your initial code.
Every time you run the generator it will override the files it needs, so you must be careful not to override any of your changes.
For this you can add a `.openapi-generator-ignore` which works similar to `.gitignore`.
It allows you to define what files should not be (re-)generated.