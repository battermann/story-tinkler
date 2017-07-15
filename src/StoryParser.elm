module StoryParser exposing (..)

import Types exposing (..)
import Combine exposing (..)
import Combine.Char exposing (..)


ignore : a -> ()
ignore =
    \_ -> ()


asterisks : String
asterisks =
    "***"


word : Parser s String
word =
    String.fromList <$> (manyTill anyChar (choice [ ignore <$> whitespace1, end ]))


token : Parser s res -> Parser s res
token =
    between whitespace whitespace


wordToken : Parser s String
wordToken =
    token word


stringToken : String -> Parser s String
stringToken str =
    token (string str)


keyValue : String -> Parser s a -> Parser s a
keyValue key valueP =
    stringToken key
        *> stringToken ":"
        *> valueP


dash : Parser s ()
dash =
    ignore <$> stringToken "-"


id : Parser s Id
id =
    dash
        *> keyValue "id" (Id <$> wordToken)


prompt : Parser s Prompt
prompt =
    dash
        *> keyValue "prompt" (String.fromList >> String.trim >> Prompt <$> manyTill anyChar newline)


next : Parser s Id
next =
    keyValue "next" (Id <$> wordToken)


continuation : Parser s ( Prompt, Id )
continuation =
    prompt
        >>= \p -> ((\n -> ( p, n )) <$> next)


continuations : Parser s (List ( Prompt, Id ))
continuations =
    dash
        *> stringToken "continue"
        *> stringToken ":"
        *> many1 continuation


separator : Parser s ()
separator =
    whitespace
        *> string asterisks
        *> (ignore <$> newline)


content : Parser s Content
content =
    String.fromList >> Content <$> manyTill anyChar (choice [ end, lookAhead separator, lookAhead (ignore <$> continuations) ])


section : Parser s Section
section =
    separator
        *> id
        >>= \i ->
                content
                    >>= \c -> (\nexts -> { id = i, content = c, nexts = nexts, goBackOption = CanGoBack }) <$> (choice [ continuations, (\_ -> []) <$> end, (\_ -> []) <$> (lookAhead separator) ])


sections : Parser s (List Section)
sections =
    many1 section


parseStory : String -> Result String (List Section)
parseStory story =
    case parse sections story of
        Ok ( _, _, res ) ->
            Ok res

        Err ( _, _, ms ) ->
            Err (ms |> String.join "\n")
