module Request.Helpers exposing (errorHttp2String)

import Http exposing (Error, Response)


errorHttp2String : Http.Error -> String
errorHttp2String error =
    case error of
        Http.BadUrl badUrl ->
            "Bad Url : " ++ badUrl

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus response ->
            "Bad Status : " ++ toString response.status.code

        Http.BadPayload msg response ->
            -- TODO à compléter
            "Bad Payload : " ++ msg
