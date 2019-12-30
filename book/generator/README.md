# Generator

The OpenAPI Generator can automatically generate source code for many different programming languages.
This allows you to create your back-end code and Elm code using the same specification.
This contract ensures your Elm code always gets the data it expects.

There are multiple ways to run the [generator](https://openapi-generator.tech/), e.g. using a jar, docker image or npm.
However, the latest Elm generator is part of the _upcoming_ major release as is **only available via a snapshot release**.
This release requires Java and can be found [here](https://oss.sonatype.org/content/repositories/snapshots/org/openapitools/openapi-generator-cli/5.0.0-SNAPSHOT/). Download it and run the generator as follows:

```
cd /path/to/project
java -jar /path/to/openapi-generator-cli.jar generate -g elm -i openapi.yaml -o generated
elm-format --yes generated # optional
```

## Generating files

The OpenAPI Generator normally generates a fully functional project in your programming language of choice.
However, this is not always perfect as you typically have set-up your own project.
Therefore, the generated Elm code only contains the required files and an `elm.json` for reference.

Hence, the generator can be used in either of the two following ways.
In either case I advice not to put any generated code under version control.

### Modify `elm.json`

Generate your Elm code in a sub-directory of your Elm project.
Add the path to the `source_directories` of your `elm.json`.
For example, with the output directory set to `generated` you add `generated/src` to the source directories.
This makes the additional source files available to your project.
This configuration is also used in the [Example](example.md) and is the recommended approach.

### Add `.openapi-generator-ignore`

When you do not have any project yet, you can use the output of the generator as your initial code.
Every time you run the generator it will override the files it generates, so you must be careful not to override any of your changes.
For this you can add a `.openapi-generator-ignore` which works similar to `.gitignore`.
It allows you to define what files should no longer be generated.