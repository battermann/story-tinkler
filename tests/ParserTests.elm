module ParserTests exposing (..)
 
import Expect exposing (Expectation)
import Test exposing (..)
import Combine exposing (..)
import StoryParser exposing (..)
import TestData
import Types exposing (..)

run : Parser () a -> String -> Result String a
run p input =
    case parse p input of
        Ok (_, _, res) -> 
            Ok res
        Err (_, _, errors) ->
            Err (String.join " or " errors)

suite : Test
suite =
    describe "parsing input test suite"
        [ test "wordToken should return string in between whitespaces" <|
            \() -> 
                Expect.equal (Ok "Hello") (run wordToken "   Hello World! ")
        , test "id should return correct Id" <|
            \() ->
                Expect.equal (Ok (Id "foo")) (run id "- id: foo")   
        , test "continuations should return correct list" <|
            \() ->
                Expect.equal (Ok [(Prompt "Do you want to go to A?", Id "a"), (Prompt "Or do you want to go to B?", Id "b")]) (run continuations TestData.continuations) 
        , test "section should return correct section" <|
            \() ->
                Expect.equal (Ok (Id "root", Content "# Introduction\n\nbla bla bla", [(Prompt "Do you want to go to A?", Id "a"), (Prompt "Or do you want to go to B?", Id "b")])) (run section TestData.section)                                                
        ]
