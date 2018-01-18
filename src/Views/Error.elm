module Views.Error exposing (errorLocation2String, view)

import Geolocation exposing (Error(..))
import Html exposing (Html, div, h1, text)
import Http exposing (Error)
import Messages exposing (..)
import Request.Helpers exposing (errorHttp2String)


view : Maybe Http.Error -> {- Maybe Geolocation.Error -> -} Html Msg
view eHttp =
    {- eLoc -}
    div []
        [ viewEHttp eHttp

        {- , viewELoc eLoc -}
        ]


viewEHttp : Maybe Http.Error -> Html Msg
viewEHttp error =
    case error of
        Nothing ->
            div [] []

        Just error ->
            div [] [ text (errorHttp2String error) ]



{-
   viewELoc : Maybe Geolocation.Error -> Html Msg
   viewELoc error =
       case error of
           Nothing ->
               div [] []

           Just error ->
               div [] [ text (errorLocation2String error) ]

-}


errorLocation2String : Geolocation.Error -> String
errorLocation2String error =
    case error of
        PermissionDenied msg ->
            "Permission denied: " ++ msg

        LocationUnavailable msg ->
            "Location unavailable: " ++ msg

        Timeout msg ->
            "Timeout: " ++ msg
