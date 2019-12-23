# Schemas

This section describes what Elm types are being generated from certain OpenAPI schemas.
Each sub-section contains one or more OpenAPI schemas, a description and the resulting Elm code.
The JSON encoders and decoders are not shown as they are not relevant for using the types.

## Primitives

```yaml
components:
  schemas:
    Primitive:
      properties:
        string:
          type: string
        number:
          type: number
        float:
          type: number
          format: float
        double:
          type: number
          format: double
        integer:
          type: integer
        short:
          type: integer
          format: int32
        long:
          type: integer
          format: int64
        boolean:
          type: boolean
```

The `Float` type in Elm is a 64 bit floating point number. Hence every `number` type is generated as a `Float`.
The `Int` type however does not use a 64 bit representation. Currently, the generator ignores this fact and generates all `integer`s as an `Int`.

```elm
type alias Primitive =
    { string : Maybe String
    , number : Maybe Float
    , float : Maybe Float
    , double : Maybe Float
    , integer : Maybe Int
    , short : Maybe Int
    , long : Maybe Int
    , boolean : Maybe Bool
    }
```

## Enumerations

```yaml
components:
  schemas:
    Enum:
      type: enum
      enum:
        - foo
        - bar
        - baz
```

OpenAPI enumerations are generated as Elm custom types.
Both string and integer values are supported.
The generator also exposes a function to get a list of all available variants.

```elm
type Enum
    = EnumFoo
    | EnumBar
    | EnumBaz


enumVariants =
    [ EnumFoo
    , EnumBar
    , EnumBaz
    ]
```

# Arrays

```yaml
components:
  schemas:
    Array:
      required:
        - array
        - arrayOfArray
      properties:
        array:
          type: array
          items:
            type: string
        arrayOfArray:
          type: array
          items:
            type: array
            items:
              type: string
```

Arrays becomes `List`s. Their items must always be present and not `null`.

```elm
type alias Array =
    { array : List (String)
    , arrayOfArray : List (List (String))
    }
```

## `required` and `nullable`

```yaml
components:
  schemas:
    Absent:
      required:
        - required
        - nullable
      properties:
        default:
          type: string
        required:
          type: string
        nullable:
          type: string
          nullable: true
        requiredNullable:
          type: string
          nullable: true
```

Officially, `required` and `nullable` should confirm to the following spec (✔ valid, ✘ invalid):

| `required` | `nullable` | `{}` | `{ value: null }` |
| ---------- | ---------- | ---- | ----------------- |
| `false`    | `false`    | ✔   | ✘                 |
| `true`     | `false`    | ✘   | ✘                 |
| `false`    | `true`     | ✔   | ✔                 |
| `true`     | `true`     | ✘   | ✔                 |

However, to fully support this the generator either needs a `Maybe (Maybe a)` for required, nullable fields or a new custom type.
For simplicity reasons absent and `null` values are handled in a similar way, i.e. using a `Maybe`.

```elm
type alias Absent =
    { default : Maybe String
    , required : String
    , nullable : Maybe String
    , requiredNullable : Maybe String
    }
```

## `AllOf`

```yaml
components:
  schemas:
    Composed:
      description: Composed Model
      allOf:
        - $ref: "#/components/schemas/ComposedBase"
        - type: object
          properties:
            value:
              type: string
    ComposedBase:
      required:
        - base
      properties:
        base:
          type: number
```

Using `allOf` composes a new record using the properties from another schema.
In the Elm code, `Composed` has no reference to `ComposedBase` here.
See the next section on how to keep a hierarchy between the two.

```elm
type alias Composed =
    { base : Float
    , value : Maybe String
    }


type alias ComposedBase =
    { base : Float
    }
```

## `AllOf` with discriminator

```yaml
components:
  schemas:
    Discriminated:
      description: Discriminated model
      required:
        - kind
      properties:
        kind:
          type: string
      discriminator:
        propertyName: kind
    DiscriminatedA:
      allOf:
        - $ref: "#/components/schemas/Discriminated"
        - type: object
          properties:
            a:
              type: string
    DiscriminatedB:
      allOf:
        - $ref: "#/components/schemas/Discriminated"
        - type: object
          properties:
            b:
              type: string
```

Using `allOf` in combination with a `discriminator` results in two things:

* a custom type is generated with variants for each discriminated type and a _catch-all_ variant for all other discriminator values;
* all variants add the base type via composition.

```elm
type Discriminated
    = Discriminated BaseDiscriminated
    | DiscriminatedDiscriminatedA DiscriminatedA
    | DiscriminatedDiscriminatedB DiscriminatedB


type alias BaseDiscriminated =
    { kind : String
    }


type alias DiscriminatedA =
    { baseDiscriminated: BaseDiscriminated
    , a : Maybe String
    }


type alias DiscriminatedB =
    { baseDiscriminated: BaseDiscriminated
    , b : Maybe String
    }
```

## `OneOf`

```yaml
components:
  schemas:
    OneOf:
      oneOf:
        - $ref: "#/components/schemas/OneOfA"
        - $ref: "#/components/schemas/OneOfB"
    OneOfA:
      properties:
        a:
          type: string
    OneOfB:
      properties:
        b:
          type: string
```

Using `oneOf` makes Elm decode into one of the specified models.
A custom type is generated that wraps all the different models.
You may provide an additional `discriminator` to specify exactly what model you wish to decode to.

```elm
type OneOf
    = OneOfOneOfA OneOfA
    | OneOfOneOfB OneOfB


type alias OneOfA =
    { a : Maybe String
    }


type alias OneOfB =
    { b : Maybe String
    }
```

## Recursion

```yaml
components:
  schemas:
    Recursion:
      properties:
        maybe:
          $ref: "#/components/schemas/Recursion"
        list:
          type: array
          items:
            $ref: "#/components/schemas/Recursion"
        ref:
          $ref: "#/components/schemas/RecursionLoop"
    RecursionLoop:
      properties:
        ref:
          $ref: "#/components/schemas/Recursion"
```

OpenAPI allows you to specify recursive types.
Elm cannot handle [recursive type aliases](https://elm-lang.org/0.19.0/recursive-alias).
Therefore, when generating recursive types, addition types are generated that wrap the recursive properties in new types.

```elm
type alias Recursion =
    { maybe : RecursionMaybe
    , list : RecursionList
    , ref : RecursionRef
    }


type RecursionMaybe = RecursionMaybe (Maybe Recursion)


type RecursionList = RecursionList (Maybe (List (Recursion)))


type RecursionRef = RecursionRef (Maybe RecursionLoop)


type alias RecursionLoop =
    { ref : RecursionLoopRef
    }


type RecursionLoopRef = RecursionLoopRef (Maybe Recursion)
```

## Reserved words

```yaml
components:
  schemas:
    Maybe:
      properties:
        type:
          type: string
        if:
          type: boolean
```

Reserverd words get escaped by adding a `_` suffix.
The generated encoders and decoders do use the originally specified property names.

```elm
type alias Maybe_ =
    { type_ : Maybe String
    , if_ : Maybe Bool
    }
```

## Unsafe characters

```yaml
components:
  schemas:
    UnsafeCharacters:
      properties:
        $prefix:
          type: string
        suffix$:
          type: string
        r@nd0m_$t#ff:
          type: string
        _before:
          type: string
        after_:
          type: string
        _both_:
          type: string
        in_the_middle:
          type: string
```

Unsafe characters are filtered out.
The generated encoders and decoders do use the originally specified property names.

```elm
type alias UnsafeCharacters =
    { prefix : Maybe String
    , suffix : Maybe String
    , rnd0mTff : Maybe String
    , before : Maybe String
    , after : Maybe String
    , both : Maybe String
    , inTheMiddle : Maybe String
    }
```
