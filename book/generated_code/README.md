
# Generated code

The generated Elm code consists of two major parts:
* Types, i.e. records (type aliases), custom types and custom types with data.
  All types are written the `Api/Data.elm` module;
* `Request`s for making HTTP requests.
  This type splits the native [`Http.request`](https://package.elm-lang.org/packages/elm/http/latest/Http#request) into two:
  (1) define the request to be made and
  (2) send the request via a command and a `msg`.

The OpenAPI generator also generates a base module `Api.elm` containing the `Request` type and several useful library functions.
The most important is the `send` function that allows you to convert a `Request` to a `Cmd msg`.
See [Customization](../customization.md) for more advanced usages.

The generator uses as little dependencies as possible.
However, when using one of the following OpenAPI formats you will need to load additional libraries:
* `date` or `date-time` requires `elm/time` and `rtfeldman/elm-iso8601-date-strings` (via `Api/Time.elm`);
* `uuid` requires `danyx23/elm-uuid`.

The next sections give some examples on OpenAPI specifications and the corresponding generated Elm code.
