module Route exposing (fromLocation, href, modifyUrl, newUrl)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Messages exposing (..)
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


route : Parser (Step -> a) a
route =
    oneOf
        [ Url.map StepInit (s "")
        , Url.map StepError (s "error")
        , Url.map StepContracts (s "contracts")
        , Url.map StepStations (s "stations")
        , Url.map StepStation (s "station")
        ]



-- INTERNAL --


routeToString : Step -> String
routeToString page =
    let
        pieces =
            case page of
                StepInit ->
                    []

                StepError ->
                    [ "error" ]

                StepContracts ->
                    [ "contracts" ]

                StepStations ->
                    [ "stations" ]

                StepStation ->
                    [ "station" ]
    in
    "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


href : Step -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Step -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


newUrl : Step -> Cmd msg
newUrl =
    routeToString >> Navigation.newUrl


fromLocation : Location -> Maybe Step
fromLocation location =
    if String.isEmpty location.hash then
        Just StepInit
    else
        parseHash route location
