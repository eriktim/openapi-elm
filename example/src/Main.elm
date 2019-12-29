module Main exposing (main)

import Api
import Api.Data as Data
import Api.Request.Swapi as Swapi
import Browser
import Dict
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Http


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { page : Int
    , state : State
    }


type State
    = Loading
    | Loaded PlanetList
    | Errored String


type alias PlanetList =
    { count : Int
    , planets : List Planet
    }


type alias Planet =
    { id : String
    , name : String
    , population : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    loadPlanetPage 1



-- UPDATE


type Msg
    = PlanetsLoaded (Result Http.Error PlanetList)
    | ClickedPreviousPage
    | ClickedNextPage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlanetsLoaded (Ok list) ->
            ( { model | state = Loaded list }, Cmd.none )

        PlanetsLoaded (Err err) ->
            ( { model | state = Errored <| errorToString err }, Cmd.none )

        ClickedPreviousPage ->
            loadPlanetPage (model.page - 1)

        ClickedNextPage ->
            loadPlanetPage (model.page + 1)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Html.div [ Attr.style "margin" "12px" ] [ viewPlanets model ]


viewPlanets : Model -> Html Msg
viewPlanets { page, state } =
    case state of
        Loading ->
            Html.text "Loading..."

        Loaded data ->
            Html.div []
                [ viewPagination page (numPages data.count)
                , Html.table [] <|
                    [ Html.caption [] [ Html.text "Planets" ]
                    , Html.thead []
                        [ Html.tr []
                            [ Html.th [] [ Html.text "ID" ]
                            , Html.th [] [ Html.text "Name" ]
                            , Html.th [] [ Html.text "Population" ]
                            ]
                        ]
                    ]
                        ++ List.map viewPlanet data.planets
                ]

        Errored reason ->
            Html.text <| "Request failed: " ++ reason


viewPlanet : Planet -> Html Msg
viewPlanet planet =
    Html.tr []
        [ Html.td [] [ Html.text planet.id ]
        , Html.td [] [ Html.text planet.name ]
        , Html.td [] [ Html.text planet.population ]
        ]


viewPagination : Int -> Int -> Html Msg
viewPagination page pageCount =
    let
        prevAttr =
            if page > 1 then
                [ Attr.style "cursor" "pointer"
                , Events.onClick ClickedPreviousPage
                ]

            else
                [ Attr.style "color" "white " ]

        nextAttr =
            if page < pageCount then
                [ Attr.style "cursor" "pointer"
                , Events.onClick ClickedNextPage
                ]

            else
                [ Attr.style "color" "white " ]

        attr =
            [ Attr.style "margin-left" "8px"
            , Attr.style "margin-right" "8px"
            ]
    in
    Html.div [ Attr.style "margin-bottom" "24px" ]
        [ Html.span prevAttr [ Html.text "<" ]
        , Html.span attr [ Html.text <| "page " ++ String.fromInt page ++ " of " ++ String.fromInt pageCount ]
        , Html.span nextAttr [ Html.text ">" ]
        ]



-- HELPER


getPlanets : Maybe Int -> Api.Request PlanetList
getPlanets page =
    Swapi.getPlanets page
        |> Api.map mapPlanets


loadPlanetPage : Int -> ( Model, Cmd Msg )
loadPlanetPage page =
    ( { page = page, state = Loading }
    , Api.send PlanetsLoaded (getPlanets <| Just page)
    )


mapPlanets : Data.PlanetList -> PlanetList
mapPlanets planets =
    { count = planets.count
    , planets = List.map mapPlanet planets.results
    }


mapPlanet : Data.Planet -> Planet
mapPlanet planet =
    { id = lastPart planet.url
    , name = planet.name
    , population = planet.population
    }


lastPart : String -> String
lastPart str =
    String.split "/" str
        |> List.filter (not << String.isEmpty)
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""


numPages : Int -> Int
numPages count =
    ceiling (toFloat count / 10.0)


errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus code ->
            "Bad status " ++ String.fromInt code

        Http.BadBody message ->
            message
