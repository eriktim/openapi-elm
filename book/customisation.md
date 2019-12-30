# Customisation

The `Request` type is a _opaque_ type that describes how to make an HTTP request.
Each `Request` can be customised using the update functions in `Api.elm`, e.g. for adding headers, changing the base path or setting a timeout. Using the `send` function and a `Msg` the request can be converted to a `Cmd Msg` which allows Elm to make the actual call.

The customisation also allows you to set-up your own generic solution for making HTTP requests.
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

Now throughout your program you can use this function instead of the default `Api.send`.

The following sub-sections explain the possibile customisations.

### `map`

`Api.map` allows you to change the return type of a `Request`.
This may be usefull when the OpenAPI specification returns a different type from what you would like to use.

An example:

```elm
-- generated code
updateUser : Api.Data.User -> Api.Request Api.Data.User

toCustomUser : Api.Data.User -> CustomUser

fromCustomUser : CustomUser -> Api.Data.User

updateCustomUser : CustomUser -> Api.Request CustomUser
updateCustomUser = Api.map toCustomUser << updateUser << fromCustomUser
```

### `withBasePath`

You can override the base path as defined in the OpenAPI specification.
You can do this per request or you can fully customise the `Api.send`.

An example:

```elm
sendWithBasePath : (Result Http.Error a -> msg) -> Request a -> Cmd msg
sendWithBasePath toMsg request =
    request
        |> Api.withBasePath "http://elm-lang.org"
        |> Api.send toMsg
```

### `withTimeout`

By default, Elm HTTP requests have no timeout.
You can set one per request or you can fully customise the `Api.send`.
The timeout is defined in milliseconds.

An example:

```elm
sendWithTimeout : (Result Http.Error a -> msg) -> Request a -> Cmd msg
sendWithTimeout toMsg request =
    request
        |> Api.withTimeout 30000
        |> Api.send toMsg
```

### `withTracker`

Elm HTTP allows you to [track](https://package.elm-lang.org/packages/elm/http/latest/Http#track) requests.
Setting the same tracker for each request probably does not make much sense, but you can set one per requests or fully customise the `Api.send` to accept one.

An example:

```elm
sendAndTrack : String -> (Result Http.Error a -> msg) -> Request a -> Cmd msg
sendAndTrack tracker toMsg request =
    request
        |> Api.withTracker tracker
        |> Api.send toMsg
```

### `withHeader` and `withHeaders`

OpenAPI allows you to specify what headers need to be send.
On top of that you can define your own additional (set of) header(s) on each request.

An example:

```elm
sendAuthenticated : String -> (Result Http.Error a -> msg) -> Request a -> Cmd msg
sendAuthenticated token toMsg request =
    request
        |> Api.withHeader "ACCESS_TOKEN" token
        |> Api.send toMsg
```
