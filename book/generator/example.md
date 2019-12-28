# Example

This example uses the [Star Wars API](https://swapi.co/).
See the [example source code](https://github.com/eriktim/openapi-elm/tree/master/example).

```bash
cd example
openapi-generator generate -g elm -i swapi.yaml -o generated
elm reactor # visit http://localhost:8000/src/Main.elm
```