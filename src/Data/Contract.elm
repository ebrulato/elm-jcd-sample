{-
   {
     "name" : "Paris",
     "commercial_name : " : "Vélib'",
     "country_code" : "FR",
     "cities" : [
       "Paris",
       "Neuilly",
       ...
     ]
   }
-}


module Data.Contract exposing (Contract, decoder)

import Json.Decode as Decode exposing (Decoder, bool, list, string)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Contract =
    { name : String
    , commercial_name : String
    , country_code : String
    , cities : List String
    }


decoder : Decoder Contract
decoder =
    decode Contract
        |> required "name" string
        |> required "commercial_name" string
        |> required "country_code" string
        |> required "cities" (list string)
