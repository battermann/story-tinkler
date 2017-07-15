module App exposing (..)

import Html exposing (..)
import State exposing (..)
import Types exposing (..)
import View exposing (root)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = root
        , update = update
        , subscriptions = \m -> Sub.none
        }
