# Paths

## Body, response, tags & operations

```yaml
paths:
  /data:
    post:
      tags:
        - Primitive
      operationId: update
      requestBody:
        description: Request body
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/Primitive"
      responses:
        "200":
          description: Default response
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Primitive"
```

Adding a `application/json` request body and response result in the function as follows:

```elm
update : Api.Data.Primitive -> Api.Request Api.Data.Primitive
```

Using a tag puts the generated request in a module with that name.
If you do not use a tag, the `Default` module is used.
Using `operationId` allows you to set the name of the function.
If absent, the function name is created automatically.


### Path

```yaml
paths:
  /path/{string}/{integer}:
    get:
      parameters:
        - name: string
          in: path
          schema:
            type: string
        - name: integer
          in: path
          schema:
            type: integer
      responses:
        "200":
          description: Default response
```

A path may contain variables.
The generator will add them as **required** parameters to your function.

```elm
pathStringIntegerGet : String -> Int -> Api.Request ()
```
### Query

```yaml
paths:
  /query:
    get:
      parameters:
        - name: string
          in: query
          schema:
            type: string
        - name: int
          in: query
          schema:
            type: integer
        - name: enum
          in: query
          schema:
            type: string
            enum: [a, b, c]
      responses:
        "200":
          description: Default response
```

You may add query parameters as well.

```elm
type Enum
    = EnumA
    | EnumB
    | EnumC


enumVariants =
    [ EnumA
    , EnumB
    , EnumC
    ]


queryGet : Maybe String -> Maybe Int -> Maybe Enum -> Api.Request ()
```

### Headers

```yaml
paths:
  /header:
    post:
      parameters:
        - name: string
          in: header
          required: true
          schema:
            type: string
        - name: integer
          in: header
          schema:
            type: integer
      responses:
        "200":
          description: Default response
          content:
            application/json:
              schema:
                type: string
```

OpenAPI also allows you to add headers to each request.
Note that one of the headers is required while the other is not.

```elm
headerPost : String -> Maybe Int -> Api.Request String
```