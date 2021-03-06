# Customization

The `Request` type is a _opaque_ type that describes how to make an HTTP request.
Each `Request` can be customized using the update functions in `Api.elm`, e.g. for adding headers, changing the base path or setting a timeout. Using the `send` function and a `Msg` the request can be converted to a `Cmd Msg` which allows Elm to make the actual call.

The customization also allows you to set-up your own generic solution for making HTTP requests.
Let's say you need to add an authentication header to each request and your base path is loaded from your program's flags.
You capture this data and store it in a `Server` record.
The customization enables you to define your own `send` function like this:

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

The following sub-sections explain the possible customizations.

### `map`

`Api.map` allows you to change the return type of a `Request` by mapping a `Request a` to a `Request b`.
This may be useful when the OpenAPI specification returns a different type from what you would like to use.

As an example let's assume we generated the following function:

```elm
updateUser : Api.Data.User -> Api.Request Api.Data.User
```

`updateUser` takes and gives us a `Api.Data.User`. If we rather work with our
own `CustomUser` instead we can map both the input and the output types using
composition and `Api.map`:

```elm
toCustomUser : Api.Data.User -> CustomUser

fromCustomUser : CustomUser -> Api.Data.User

updateCustomUser : CustomUser -> Api.Request CustomUser
updateCustomUser = Api.map toCustomUser << updateUser << fromCustomUser
```

We now should use `updateCustomUser` instead of `updateUser`.

### `withBasePath`

You can override the base path as defined in the OpenAPI specification.
You can do this per request or you can fully customize the `Api.send`.

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
Setting the same tracker for each request probably does not make much sense, but you can set one per requests or fully customize the `Api.send` to accept one.

An example:

```elm
sendAndTrack : String -> (Result Http.Error a -> msg) -> Request a -> Cmd msg
sendAndTrack tracker toMsg request =
    request
        |> Api.withTracker tracker
        |> Api.send toMsg
```

### `withBearerToken`

OpenAPI allows you to specify what security scheme your API uses.
When using bearer authorization a header with the token is added using this function.

An example:

```elm
sendAuthenticated : String -> (Result Http.Error a -> msg) -> Request a -> Cmd msg
sendAuthenticated token toMsg request =
    request
        |> Api.withBearerToken token
        |> Api.send toMsg
```

### `withHeader` and `withHeaders`

OpenAPI allows you to specify what headers need to be send.
On top of that you can define your own additional (set of) header(s) on each request.

An example:

```elm
sendWithHeader : (Result Http.Error a -> msg) -> Request a -> Cmd msg
sendWithHeader toMsg request =
    request
        |> Api.withHeader "Max-Forwards" "10"
        |> Api.send toMsg
```

### `send` and `sendWithCustomError`

The basic `send` function takes a `Request a` and eventually results in a message of `Result Http.Error a` once the `Cmd` is handled by the Elm runtime.
`sendWithCustomError` allows you to map the `Http.Error` before making the actual request.
This allows you to add custom error handling for all your requests.

An example:

```elm
type ApiError
    = Unauthorized
    | Forbidden
    | NotFound
    | ApiError String


sendWithCustomError : (Result ApiError a -> msg) -> Request a -> Cmd msg
sendWithCustomError =
    Api.sendWithCustomError (\result ->
        case result of
            Ok v ->
                Ok v

            Err (BadUrl _) ->
                ApiError "Oops, we messed up!"

            Err Timeout ->
                ApiError "Server timeout. Please try again later."

            Err NetworkError ->
                ApiError "Network error."

            Err (BadStatus code) ->
                case code of
                    401 ->
                        Unauthorized

                    403 ->
                        Forbidden

                    404 ->
                        NotFound

                    _ ->
                        ApiError "Oops, the request failed."

            Err (BadBody _) ->
                ApiError "Oops, we messed up!"
    )
```

### `task`

Just like Elm's Http library, the generator also supports both commands and tasks.
You can use `task` to create a `Task` from a `Request`.
If you simply need a `Cmd msg` then `send` is the better option here.

Note: _tracking_ requests is not supported when using tasks as it is also not supported in the native library.
