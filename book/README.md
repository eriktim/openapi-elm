# Elm with OpenAPI

This small guide aims to explain how to use the OpenAPI Generator with Elm
and to give some background on what is being generated.

[OpenAPI](https://www.openapis.org) is an initiative to standardise REST APIs.
The [OpenAPI Generator](https://openapi-generator.tech/) enable automatic generation of server interfaces, server stubs, clients (like the one for Elm) and documentation.

I do not want to go into details on the specification as that can be found on the [official website](http://spec.openapis.org/oas/v3.0.2).

A few advantages of working with OpenAPI are:

* It defines a clear contract between front-end and back-end, making it easier to collaborate;
* For Elm it means you no longer have to write your own JSON decoders & encoders as they can be generated automatically;
* It keeps your data transfer models uncoupled from your internal data models;
* It forces you to design your REST APIs in a language agnostic fashion;
* It enables easy refactoring as updating your specification will result in compile time errors on both server and client side;
* Your specification is also your (to be generated) documentation.