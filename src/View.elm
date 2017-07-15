module View exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, attribute, id)
import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Bootstrap.Navbar as Navbar
import Bootstrap.CDN as CDN
import List.Extra exposing (last, init)
import Markdown exposing (toHtml)


toHtml : Content -> Html msg
toHtml (Content input) =
    Markdown.toHtml [] input


renderOptions : GoBackOption -> List ( Prompt, Id ) -> List (Html Msg)
renderOptions goBackOption nexts =
    let
        nextsButtons =
            nexts |> List.map (\( Prompt q, id ) -> Button.button [ Button.info, Button.onClick (Choose id), Button.large, Button.block ] [ i [ class "fa fa-plus-square", attribute "aria-hidden" "true" ] [], text (" " ++ q) ])

        nextsWithMaybeGoBack =
            case goBackOption of
                CanGoBack ->
                    Button.button [ Button.secondary, Button.onClick Back, Button.large, Button.block ] [ i [ class "fa fa-undo", attribute "aria-hidden" "true" ] [], text " undo" ] :: nextsButtons

                None ->
                    nextsButtons
    in
        if List.isEmpty nextsWithMaybeGoBack then
            []
        else
            nextsWithMaybeGoBack


renderSection : Section -> Html Msg
renderSection section =
    toHtml section.content

addSeparator : List (Html a) -> List (Html a)
addSeparator xs =
    List.intersperse (hr [] []) xs

renderSections : List Section -> Html Msg
renderSections sections =
    let
        tail =
            List.tail sections |> Maybe.withDefault []

        maybeCurrent =
            List.head sections
                |> Maybe.map
                    (\l ->
                        div []
                            (toHtml l.content :: renderOptions l.goBackOption l.nexts)
                    )
    in
        div [] ( addSeparator (((Maybe.withDefault (text "") maybeCurrent) :: (tail |> List.map renderSection))) )


root : Model -> Html Msg
root model =
    let
        content = 
            case model of
                Ok m ->
                    [ div [] [ renderSections m.selected ] ]

                Err err ->
                    [ h1 [] [ text "Oops, an error occurred" ], text err ]
    in
        Grid.container [ ] ( CDN.stylesheet :: CDN.fontAwesome :: content)
        