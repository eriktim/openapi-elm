# Example

> Note: Currently, the Elm generator is not yet available via normal releases.
> You can download the latest snapshot release from [this page](https://oss.sonatype.org/content/repositories/snapshots/org/openapitools/openapi-generator-cli/5.0.0-SNAPSHOT/).

This example uses the [Star Wars API](https://swapi.dev/).
See the [example source code](https://github.com/eriktim/openapi-elm/tree/master/example).
The provided OpenAPI specification only covers part of the Star Wars API, namely getting a paginated list of planets or a specific one.
As the model does not exactly match the data we want to have in Elm we use `Api.map` to map to a custom model instead.

You can either view the [live example](https://eriktim.github.io/openapi-elm/example/) or run it locally:

```bash
cd example
java -jar openapi-generator-cli.jar generate -g elm -i swapi.yaml -o generated
elm reactor # visit http://localhost:8000/src/Main.elm
```

As an exercise try any of the following:

* Add the diameter and edited timestamp of each planet to the table;
* Make each table row navigate to a new page where you fetch the data for that planet only;
* Concatenate all data from all planets and show them in the table (without pagination);
* Update the specification and try fetching Star Wars [people](https://swapi.dev/documentation#people) as well.