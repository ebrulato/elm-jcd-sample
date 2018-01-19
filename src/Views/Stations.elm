module Views.Stations exposing (view)

import Data.Station exposing (Station)
import Html exposing (Html, article, div, h1, text)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Tachyons exposing (classes)
import Tachyons.Classes exposing (..)
import Views.StationDistance exposing (viewDistance)


view : List Station -> Html Msg
view stations =
    div [] (List.map viewStationCard stations)


viewStationCard : Station -> Html Msg
viewStationCard s =
    article [ classes [ link, black, dim, w_90, center, shadow_1, bg_white, mv2, ba, br1, b__black_10 ] ]
        [ div
            [ classes [ flex, flex_column, w_90, center ]
            , onClick (OnSeclectStation s.number)
            ]
            [ div [ classes [ w_two_thirds, pa1 ] ]
                [ div [ classes [ f3, tl ] ] [ text s.name ]
                , div [ classes [ flex ] ]
                    [ div [ classes [ w_two_thirds, f4, tl, gray ] ] [ text s.address ]
                    , div [ classes [ w_third, f5, tr, gray, self_end ] ] [ viewDistance s ]
                    ]
                ]
            ]
        ]
