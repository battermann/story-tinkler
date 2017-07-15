module State exposing (init, update)

import StoryParser exposing (parseStory)
import Types exposing (..)
import List.Extra
import Http
import Validator
import Dom.Scroll exposing (..)
import Task


getStory : Cmd Msg
getStory =
    let
        r =
            Http.getString "/story.txt"
    in
        Http.send Story r


empty : Model
empty =
    Ok
        { all = []
        , selected = []
        }


init : ( Model, Cmd Msg )
init =
    ( empty, getStory )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Choose id ->
            let
                eitherNextOrError =
                    model
                        |> Result.map (\m -> m.all)
                        |> Result.andThen (List.Extra.find (\s -> s.id == id) >> Result.fromMaybe "could not find next section")

                newModel =
                    model
                        |> Result.andThen (\m -> eitherNextOrError |> Result.map (\next -> { m | selected = next :: m.selected }))
            in
                ( newModel, Task.attempt (always NoOp) <| toTop "top" )

        Back ->
            let
                newModel =
                    model
                        |> Result.map (\m -> { m | selected = m.selected |> List.tail >> Maybe.withDefault [] })
            in
                ( newModel, Task.attempt (always NoOp) <| toTop "top" )

        Story (Ok story) ->
            let
                newModel =
                    parseStory story
                        |> Result.andThen Validator.createValidModel
            in
                ( newModel, Cmd.none )

        Story (Err err) ->
            ( Err (toString err), Cmd.none )

        NoOp -> ( model, Cmd.none )
