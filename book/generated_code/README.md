
# Generated code

The generated Elm code consists of two major parts:
* Types, i.e. records (type aliases), custom types and custom types with data;
* `Request`s for making HTTP requests.

The `Request` type is a _opaque_ type that describes how to make a HTTP request.
Each `Request` can be customised using the update functions in `Api.elm`, e.g. adding headers, changing the base path, setting a timeout. Using the `send` function and a `Msg` the request can be converted to a `Cmd Msg` which allows Elm to make the actual call.

The customisation also allows you to set-up your own generic solution for making HTTP request.
Let's say you need to add an authentication header to each request and your base path is loaded from your program's flags.
You capture this data and store it in a `Server` record.
The customisation enables you to define your own `send` function like this:

```elm
type alias Server =
    { basePath : String
    , accessToken : String
    }

send : Server -> (Result Http.Error a -> msg) -> Request a -> Cmd msg
send { basePath, accessToken } toMsg request =
    request
        |> Api.withBasePath basePath
        |> Api.withHeader "ACCESS_TOKEN" accessToken
        |> Api.send toMsg
```

Now you can start using this `send` function instead of the default `Api.send`.

The next sections give some examples on OpenAPI specifications and the corresponding generated Elm code.
