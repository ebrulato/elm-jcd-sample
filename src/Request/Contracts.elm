module Request.Contracts exposing (get, handleRequestCompleteContracts)

--import Request.Helpers exposing (errorHttp2String)

import Data.Contract as Contract exposing (Contract, decoder)
import Http
import HttpBuilder exposing (RequestBuilder, withExpect, withQueryParams, withTimeout)
import Json.Decode exposing (list)
import Messages exposing (..)
import Time


get : String -> RequestBuilder (List Contract)
get apiKey =
    HttpBuilder.get "https://api.jcdecaux.com/vls/v1/contracts"
        |> withQueryParams [ ( "apiKey", apiKey ) ]
        --        |> withHeader "X-My-Header" "Some Header Value"
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson (list Contract.decoder))


handleRequestCompleteContracts : Result Http.Error (List Contract) -> Msg
handleRequestCompleteContracts result =
    case result of
        Ok contracts ->
            OnContracts contracts

        Err error ->
            OnError (Just error) Nothing
