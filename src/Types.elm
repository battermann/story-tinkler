module Types exposing (..)

import Http


type alias Model =
    Result String
        { all : List Section
        , selected : List Section
        }


type Msg
    = Choose Id
    | Back
    | Story (Result Http.Error String)
    | NoOp


type Id
    = Id String


type Prompt
    = Prompt String


type Content
    = Content String


type GoBackOption
    = None
    | CanGoBack


type alias Section =
    { id : Id
    , content : Content
    , nexts : List ( Prompt, Id )
    , goBackOption : GoBackOption
    }
