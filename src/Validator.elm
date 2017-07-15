module Validator exposing (createValidModel)

import Types exposing (..)
import List.Extra

checkAllIdsUnique : List Section -> Result String (List Section)
checkAllIdsUnique sections =
    let
        allUnique =
            sections
                |> List.map (\s -> s.id)
                |> List.map (\(Id id) -> id)
                |> List.Extra.allDifferent
    in
        if allUnique then
            Ok sections
        else
            Err "ids must be unique"

checkAllNextIdsExist : List Section -> Result String (List Section)
checkAllNextIdsExist sections =
    let
        missingIds = 
            sections
                |> List.Extra.andThen (\s -> s.nexts |> List.map (\(_, id) -> id))
                |> List.filter (\id -> sections |> List.map (\s -> s.id) |> List.member id |> not)
                |> List.map (\(Id id) -> id)
    in
        if List.isEmpty missingIds then
            Ok sections
        else
            Err ("missing section(s) for id(s) : [ " ++ (missingIds |> String.join ", ") ++ " ]")

mkFirstSection : List Section -> Result String (List Section)
mkFirstSection sections =
    sections 
        |> List.head 
        |> Maybe.map (\s -> { s | goBackOption = None })
        |> Maybe.map (\s -> [ s ]) 
        |> Result.fromMaybe "there must at least be one section"

createValidModel : List Section -> Model
createValidModel sections =
    checkAllIdsUnique sections
        |> Result.andThen checkAllNextIdsExist
        |> Result.andThen mkFirstSection
        |> Result.map (\first -> { all = sections, selected = first })