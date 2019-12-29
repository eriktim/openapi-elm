# Example

This example uses the [Star Wars API](https://swapi.co/).
See the [example source code](https://github.com/eriktim/openapi-elm/tree/master/example).
The OpenAPI specification only covers part of the Star Wars API, namely getting a paginated list of planets or a specific one.
As the model does not exactly match the data we want to have in Elm we use `Api.map` to map to a custom model instead.

```bash
cd example
openapi-generator generate -g elm -i swapi.yaml -o generated
elm reactor # visit http://localhost:8000/src/Main.elm
```

As an exercise try any of the following:

* Add the diameter and edited timestamp of each planet to the table;
* Make a custom command to fetch all the planets (without pagination) and show them in the table;
* Make each planet navigate to a new page where you fetch the data for that planet only.