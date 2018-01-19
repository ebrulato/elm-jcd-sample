module Views.StationDistance exposing (viewDistance)

import Data.Station exposing (Station)
import Html exposing (Html, text)
import Messages exposing (..)


viewDistance : Station -> Html Msg
viewDistance s =
    let
        dm =
            round s.distance

        dk =
            toFloat (round (toFloat dm / 100)) / 10
    in
    if s.distance < 0 then
        text ""
    else if dm > 1000 then
        text <| toString dk ++ " Km"
    else
        text <| toString dm ++ " m"
