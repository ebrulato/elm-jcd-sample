module Messages exposing (Msg(..), Step(..))

import Data.Contract exposing (Contract)
import Data.Station exposing (Station)
import Geolocation
import Http exposing (Error)


--import Navigation


type Msg
    = SetRoute (Maybe Step)
    | OnContracts (List Contract)
    | OnSelectContract String
    | OnStations (List Station)
    | OnSeclectStation Int
    | OnError (Maybe Error) (Maybe Geolocation.Error)
    | OnErrorLoc Geolocation.Error
    | OnLocation Geolocation.Location


type Step
    = StepInit
    | StepError
    | StepContracts
    | StepStations
    | StepStation
