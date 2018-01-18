{-
   Station sample
   {
     "number": 123,
     "contract_name" : "Paris",
     "name": "nom station",
     "address": "adresse indicative",
     "position": {
       "lat": 48.862993,
       "lng": 2.344294
     },
     "banking": true,
     "bonus": false,
     "status": "OPEN",
     "bike_stands": 20,
     "available_bike_stands": 15,
     "available_bikes": 5,
     "last_update": <timestamp>
   }
-}


module Data.Station exposing (Position, Station, decoder, orderStationsFromLocation)

import Geolocation
import Json.Decode as Decode exposing (Decoder, bool, float, int, string)
import Json.Decode.Pipeline as Pipeline exposing (decode, hardcoded, required)


type alias Position =
    { lat : Float
    , lng : Float
    }


type alias Station =
    { number : Int
    , contract_name : String
    , name : String
    , address : String
    , position : Position
    , banking : Bool
    , bonus : Bool
    , status : String -- TODO faire une union : OPEN,
    , bike_stands : Int
    , available_bike_stands : Int
    , available_bikes : Int
    , last_update : Int -- TODO en faire un timestamp
    , distance : Float -- distance in meter
    }


decoderPosition : Decoder Position
decoderPosition =
    decode Position
        |> required "lat" float
        |> required "lng" float


decoder : Decoder Station
decoder =
    decode Station
        |> required "number" int
        |> required "contract_name" string
        |> required "name" string
        |> required "address" string
        |> required "position" decoderPosition
        |> required "banking" bool
        |> required "bonus" bool
        |> required "status" string
        |> required "bike_stands" int
        |> required "available_bike_stands" int
        |> required "available_bikes" int
        |> required "last_update" int
        |> hardcoded -1


orderStationsFromLocation : List Station -> Geolocation.Location -> List Station
orderStationsFromLocation stations posUser =
    List.sortBy .distance (List.map (\s -> { s | distance = distance posUser s }) stations)


distance : Geolocation.Location -> Station -> Float
distance posUser station =
    let
        r =
            6371000

        l1 =
            degrees posUser.latitude

        l2 =
            degrees station.position.lat

        deltaPhi =
            degrees (station.position.lat - posUser.latitude)

        deltaLambda =
            degrees (station.position.lng - posUser.longitude)

        s1 =
            sin (deltaPhi / 2)

        s2 =
            sin (deltaLambda / 2)

        a =
            s1 * s1 + cos l1 * cos l2 * s2 * s2

        c =
            2 * atan2 (sqrt a) (sqrt (1 - a))

        d =
            r * c
    in
    d
