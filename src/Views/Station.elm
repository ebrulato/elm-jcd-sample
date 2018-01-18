module Views.Station exposing (view)

import Data.Station exposing (Station)
import Html exposing (Html, div, h1, text)
import Messages exposing (..)


view : List Station -> Maybe Int -> Html Msg
view stations number =
    let
        station =
            case number of
                Nothing ->
                    Nothing

                Just n ->
                    List.head <| List.filter (\s -> s.number == n) stations
    in
    case station of
        Nothing ->
            -- TODO go to the error view
            div [] [ text "error on the selection of a station ???" ]

        Just s ->
            div [] [ text s.name ]
