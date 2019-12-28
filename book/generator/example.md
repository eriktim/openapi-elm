# Example

This example uses the [Star Wars API](https://swapi.co/).
See the [example source code](https://github.com/eriktim/openapi-elm/tree/master/example).
The OpenAPI specification only covers part of the Star Wars API, namely get all planets or a specific one.

```bash
cd example
openapi-generator generate -g elm -i swapi.yaml -o generated
elm reactor # visit http://localhost:8000/src/Main.elm
```

As an exercise try any of the following:

* Add the population of each planet between parentheses;
* Make each planet navigate to a new page where you fetch the data for that planet only.