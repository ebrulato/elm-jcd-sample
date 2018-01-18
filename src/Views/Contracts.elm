module Views.Contracts exposing (view)

import Data.Contract exposing (Contract)
import Html exposing (Html, div, h1, text)
import Html.Events exposing (onClick)
import Messages exposing (..)


view : List Contract -> Html Msg
view contracts =
    div [] (List.map (\c -> h1 [ onClick (OnSelectContract c.name) ] [ text c.name ]) contracts)
