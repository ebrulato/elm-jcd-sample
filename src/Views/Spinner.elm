module Views.Spinner exposing (view)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Messages exposing (..)
import Views.Assets exposing (spinner, url)


view : Html Msg
view =
    div []
        [ img
            [ src (url spinner)
            ]
            []
        ]
