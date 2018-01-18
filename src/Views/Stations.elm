module Views.Stations exposing (view)

import Data.Station exposing (Station)
import Html exposing (Html, div, h1, text)
import Html.Events exposing (onClick)
import Messages exposing (..)


view : List Station -> Html Msg
view stations =
    div [] (List.map (\s -> h1 [ onClick (OnSeclectStation s.number) ] [ text (s.name ++ " (" ++ toString s.distance ++ "m)") ]) stations)
