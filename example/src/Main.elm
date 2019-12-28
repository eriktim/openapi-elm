module Main exposing (main)

import Api
import Api.Data as Data
import Api.Request.Swapi as Swapi
import Browser
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Http
import Time


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
    , planets : Planets
    }


type Planets
    = NoPlanets
    | Planets Data.PlanetList
    | Errored String


init : () -> ( Model, Cmd Msg )
init _ =
    fetchPlanets 1



-- UPDATE


type Msg
    = PlanetsLoaded (Result Http.Error Data.PlanetList)
    | ClickedPreviousPage
    | ClickedNextPage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlanetsLoaded (Ok list) ->
            ( { model | planets = Planets list }, Cmd.none )

        PlanetsLoaded (Err err) ->
            ( { model | planets = Errored <| errorToString err }, Cmd.none )

        ClickedPreviousPage ->
            fetchPlanets (model.page - 1)

        ClickedNextPage ->
            fetchPlanets (model.page + 1)


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Html.div [ Attr.style "margin" "12px" ] [ viewPlanets model ]


viewPlanets : Model -> Html Msg
viewPlanets { page, planets } =
    case planets of
        NoPlanets ->
            Html.text "Loading..."

        Planets list ->
            Html.div []
                [ Html.text <| "Planets"
                , Html.ul [] <| List.map viewPlanet list.results
                , viewPagination page (numPages list.count)
                ]

        Errored reason ->
            Html.text <| "Request failed: " ++ reason


viewPlanet : Data.Planet -> Html Msg
viewPlanet planet =
    Html.li [] [ Html.text planet.name ]


viewPagination : Int -> Int -> Html Msg
viewPagination page pageCount =
    let
        prevAttr =
            if page > 1 then
                [ Attr.style "cursor" "pointer"
                , Events.onClick ClickedPreviousPage
                ]

            else
                []

        nextAttr =
            if page < pageCount then
                [ Attr.style "cursor" "pointer"
                , Events.onClick ClickedNextPage
                ]

            else
                []

        attr =
            [ Attr.style "margin-left" "8px"
            , Attr.style "margin-right" "8px"
            ]
    in
    Html.div [ Attr.style "display" "flex" ]
        [ Html.div prevAttr [ Html.text "<" ]
        , Html.div attr [ Html.text <| "page " ++ String.fromInt page ++ " of " ++ String.fromInt pageCount ]
        , Html.div nextAttr [ Html.text ">" ]
        ]



-- HELPER


numPages : Int -> Int
numPages count =
    ceiling (toFloat count / 10.0)


fetchPlanets : Int -> ( Model, Cmd Msg )
fetchPlanets page =
    ( { page = page, planets = NoPlanets }
    , Api.send PlanetsLoaded (Swapi.getPlanets <| Just page)
    )
