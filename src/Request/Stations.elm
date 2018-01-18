module Request.Stations exposing (get, handleRequestCompleteStations)

--import Request.Helpers exposing (errorHttp2String)

import Data.Station as Station exposing (Station, decoder)
import Http
import HttpBuilder exposing (RequestBuilder, withExpect, withQueryParams, withTimeout)
import Json.Decode exposing (list)
import Messages exposing (..)
import Time


get : String -> String -> RequestBuilder (List Station)
get apiKey contract =
    HttpBuilder.get "https://api.jcdecaux.com/vls/v1/stations"
        |> withQueryParams [ ( "apiKey", apiKey ) ]
        |> withQueryParams [ ( "contract", contract ) ]
        --        |> withHeader "X-My-Header" "Some Header Value"
        |> withTimeout (10 * Time.second)
        |> withExpect (Http.expectJson (list Station.decoder))


handleRequestCompleteStations : Result Http.Error (List Station) -> Msg
handleRequestCompleteStations result =
    case result of
        Ok stations ->
            OnStations stations

        Err error ->
            OnError (Just error) Nothing
