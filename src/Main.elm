module Main exposing (..)

--import Html.Attributes exposing (href)

import Data.Contract exposing (..)
import Data.Station exposing (..)
import Geolocation exposing (Error, Location, now)
import Html exposing (Html, div, h1, img, text)
import Http exposing (Error)
import HttpBuilder exposing (send)
import Key exposing (apiKey)
import Messages exposing (..)
import Navigation
import Request.Contracts exposing (..)
import Request.Stations exposing (..)
import Result
import Route exposing (..)
import Task
import Utils exposing (..)
import Views.Contracts exposing (view)
import Views.Error exposing (errorLocation2String, view)
import Views.Spinner exposing (view)
import Views.Station exposing (view)
import Views.Stations exposing (view)


---- MODEL ----


type alias Model =
    { contracts : List Contract
    , stations : List Station
    , contractSelected : Maybe String
    , stationSelected : Maybe Int
    , errorHttp : Maybe Http.Error
    , errorLocation : Maybe Geolocation.Error
    , step : Step
    , isLoading : Bool
    , warningLocation : Maybe String
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    setRoute (Route.fromLocation location)
        { contracts = []
        , stations = []
        , contractSelected = Nothing
        , stationSelected = Nothing
        , errorHttp = Nothing
        , errorLocation = Nothing
        , step = StepInit
        , isLoading = True
        , warningLocation = Nothing
        }



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        processGeolocation : Result Geolocation.Error Geolocation.Location -> Msg
        processGeolocation result =
            case result of
                Ok loc ->
                    OnLocation loc

                Err err ->
                    OnErrorLoc err
    in
    case msg of
        SetRoute maybeStep ->
            setRoute maybeStep model

        OnContracts contracts ->
            { model | contracts = List.sortBy .name contracts, step = StepContracts, isLoading = False } => Route.newUrl StepContracts

        OnSelectContract contract ->
            -- TODO store the selected contract in the localStorage
            -- if a such value is store the application should disply
            -- this step at first
            { model | contractSelected = Just contract, isLoading = True }
                => (send handleRequestCompleteStations <|
                        Request.Stations.get apiKey contract
                   )

        OnStations stations ->
            -- we update the stations, and then try to get the location of the user
            -- If it is not the first time we bypass the geolocation process to avoid
            -- waste of time
            let
                newModel =
                    { model | stations = List.sortBy .name stations, isLoading = True }
            in
            if model.warningLocation == Nothing then
                newModel => Task.attempt processGeolocation now
            else
                { newModel | step = StepStations, isLoading = False } => Route.newUrl StepStations

        OnErrorLoc err ->
            -- we just add a warning message to explain why the stations are not ordered
            { model | warningLocation = Just (errorLocation2String err), step = StepStations, isLoading = False } => Route.newUrl StepStations

        OnLocation loc ->
            let
                stations =
                    orderStationsFromLocation model.stations loc
            in
            { model | stations = stations, step = StepStations, isLoading = False } => Route.newUrl StepStations

        OnSeclectStation number ->
            { model | stationSelected = Just number, step = StepStation, isLoading = False } => Route.newUrl StepStation

        OnError error errLoc ->
            { model | errorHttp = error, errorLocation = errLoc, step = StepError, isLoading = False } => Route.newUrl StepError



---- VIEW ----


view : Model -> Html Msg
view model =
    if model.isLoading then
        -- for the spinner :)
        Views.Spinner.view
    else
        case model.step of
            StepInit ->
                Views.Spinner.view

            StepError ->
                Views.Error.view model.errorHttp

            StepContracts ->
                Views.Contracts.view model.contracts

            StepStations ->
                Views.Stations.view model.stations

            StepStation ->
                Views.Station.view model.stations model.stationSelected



-- Routing --


setRoute : Maybe Step -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            model => Cmd.none

        Just StepInit ->
            { model | step = StepInit }
                => (send handleRequestCompleteContracts <|
                        Request.Contracts.get apiKey
                   )

        Just StepError ->
            model => Cmd.none

        Just StepContracts ->
            if List.isEmpty model.contracts then
                { model | step = StepInit } => Route.modifyUrl StepInit
            else
                { model | step = StepContracts } => Cmd.none

        Just StepStations ->
            if List.isEmpty model.stations then
                { model | step = StepInit } => Route.modifyUrl StepInit
            else
                { model | step = StepStations } => Cmd.none

        Just StepStation ->
            if model.stationSelected == Nothing then
                { model | step = StepInit } => Route.modifyUrl StepInit
            else
                { model | step = StepStation } => Cmd.none



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
