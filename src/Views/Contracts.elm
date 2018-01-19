module Views.Contracts exposing (view)

import Data.Contract exposing (Contract)
import Html exposing (Html, article, div, h2, img, text)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Tachyons exposing (classes)
import Tachyons.Classes exposing (..)
import Views.Assets exposing (flag, url)


view : List Contract -> Html Msg
view contracts =
    div [] (List.map viewContractsCard contracts)


viewContractsCard : Contract -> Html Msg
viewContractsCard c =
    article [ classes [ link, black, dim, w_90, center, shadow_1, bg_white, mv2, ba, br1, b__black_10 ] ]
        [ div
            [ classes [ flex, w_90, items_center ]
            , onClick (OnSelectContract c.name)
            ]
            [ div [ classes [ w_third, tr, pa1 ] ] [ img [ classes [ br_100, h3, w3, ba, b__black_10 ], src (url (flag c.country_code)) ] [] ]
            , div [ classes [ w_two_thirds, pa1 ] ]
                [ div [ classes [ f3, tl ] ] [ text c.name ]
                , div [ classes [ f4, tl, gray ] ] [ text c.commercial_name ]
                ]
            ]
        ]



--<img  class="" title="Photo of a kitty staring at you">
