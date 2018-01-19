module Views.Station exposing (view)

import Data.Station exposing (Station)
import Html exposing (Html, article, div, text)
import Html.Attributes exposing (href)
import Messages exposing (..)
import Tachyons exposing (classes)
import Tachyons.Classes exposing (..)
import Time
import Views.StationDistance exposing (viewDistance)


view : List Station -> Maybe Int -> Maybe Time.Time -> Html Msg
view stations number mbTime =
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
            viewStation s mbTime


viewStation : Station -> Maybe Time.Time -> Html Msg
viewStation s mbTime =
    article [ classes [ w_90, center, shadow_1, bg_white, mv2, ba, br1, b__black_10 ] ]
        [ div
            [ classes [ flex, flex_column, w_90, center ] ]
            [ div [ classes [ w_90, pa1 ] ]
                [ div [ classes [ flex ] ]
                    [ div [ classes [ f2, tl, w_two_thirds ] ] [ text s.name ]
                    , div [ classes [ f3, tl, w_third, self_start, fw7, tr ] ] [ text s.status ]
                    ]
                , div [ classes [ flex ] ]
                    [ div [ classes [ w_two_thirds, f4, tl ] ] [ Html.a [ classes [ no_underline, bg_animate, bg_white, hover_bg_light_blue, gray ], href ("https://www.google.fr/maps/@" ++ toString s.position.lat ++ "," ++ toString s.position.lng ++ ",19z") ] [ text s.address ] ]
                    , div [ classes [ w_third, f5, tr, gray, self_end ] ] [ viewDistance s ]
                    ]
                , div [ classes [ flex, mv2 ] ]
                    [ div [ classes [ w_two_thirds, f4, tl ] ] [ text "Bikes" ]
                    , div [ classes [ w_third, f4, tr, fw5 ] ] [ text (toString s.available_bikes) ]
                    ]
                , div [ classes [ flex, mv2 ] ]
                    [ div [ classes [ w_two_thirds, f4, tl ] ] [ text "Free park" ]
                    , div [ classes [ w_third, f4, tr, fw5 ] ] [ text (toString s.available_bike_stands) ]
                    ]
                , div [ classes [ flex, mv2 ] ]
                    [ div [ classes [ w_two_thirds, f4, tl ] ] []
                    , div [ classes [ w_third, f6, tr ] ] [ text (when s mbTime) ]
                    ]
                ]
            ]
        ]


when : Station -> Maybe Time.Time -> String
when s mbTime =
    case mbTime of
        Nothing ->
            ""

        Just t ->
            let
                delay =
                    (Time.inMilliseconds t - toFloat s.last_update) / 1000

                mn =
                    round (delay / 60)
            in
            toString mn ++ "mn"
