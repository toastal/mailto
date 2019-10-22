module Mailto exposing
    ( Mailto
    , Email
    , mailto, mailtoMultiple
    , subject, cc, bcc, body
    , toString, toHref
    )

{-| A small DSL to build Mailto links


# Definition

@docs Mailto


# Alias

@docs Email


# Creation

@docs mailto, mailtoMultiple


# Adding fields

@docs subject, cc, bcc, body


# Formats

@docs toString, toHref

-}

import Endo exposing (Endo, Over)
import Html
import Html.Attributes
import List.Nonempty exposing (Nonempty)
import Url.Builder exposing (QueryParameter)


{-| Just a `String` alias
-}
type alias Email =
    String


type alias M =
    { subject : Maybe String
    , cc : List Email
    , bcc : List Email
    , body : Maybe String
    }


emptyM : M
emptyM =
    { subject = Nothing
    , cc = []
    , bcc = []
    , body = Nothing
    }


toQueryParameters : M -> List QueryParameter
toQueryParameters m =
    let
        copyTo : String -> List String -> Maybe QueryParameter
        copyTo key emails =
            case emails of
                [] ->
                    Nothing

                _ ->
                    Just (Url.Builder.string key (String.join "," emails))
    in
    List.filterMap identity
        [ Maybe.map (Url.Builder.string "subject") m.subject
        , copyTo "cc" m.cc
        , copyTo "bcc" m.bcc
        , Maybe.map (Url.Builder.string "body") m.body
        ]


{-| Definition
-}
type Mailto
    = Mailto M (Nonempty Email)


{-| Constructs an empty Mailto with no parameters. It's the `singleton` of `Mailto`.
-}
mailto : Email -> Mailto
mailto =
    mailtoMultiple << List.Nonempty.fromElement


{-| Constructs an empty Mailto with no parameters, but with mailtoMultiple recipients. It's the `singleton` of `Mailto`.
-}
mailtoMultiple : Nonempty Email -> Mailto
mailtoMultiple =
    Mailto emptyM


over : Over Mailto M
over f (Mailto m email) =
    Mailto (f m) email


{-| Adds a subject to the mailto

    mailto "partner@test.mail"
        |> subject "I want to cook you dinner"
        |> toString
    -- "mailto:partner@test.mail?subject=I want to cook you dinner"

-}
subject : String -> Endo Mailto
subject subject_ =
    over (\m -> { m | subject = Just subject_ })


{-| Adds carbon copies to the mailto

    mailto "partner@test.mail"
        |> cc [ "cc@test.mail", "mutualfriend@test.mail" ]
        |> toString
    -- "mailto:partner@test.mail?cc=cc@test.mail,mutualfriend@test.mail"

-}
cc : List Email -> Endo Mailto
cc cc_ =
    over (\m -> { m | cc = cc_ })


{-| Adds blind carbon copies to the mailto

    mailto "partner@test.mail"
        |> bcc [ "bcc@test.mail", "secretfriend@test.mail" ]
        |> toString
    -- "mailto:partner@test.mail?bcc=bcc@test.mail,secretfriend@test.mail"

-}
bcc : List Email -> Endo Mailto
bcc bcc_ =
    over (\m -> { m | bcc = bcc_ })


{-| Adds a body to the mailto

    mailto "partner@test.mail"
        |> body "It will be a spicy nam dtok muu salad."
        |> toString
    -- "mailto:partner@test.mail?body=It will be a spicy nam dtok muu salad."

-}
body : String -> Endo Mailto
body body_ =
    over (\m -> { m | body = Just body_ })


{-| After composing a `Mailto`, consume a string
-}
toString : Mailto -> String
toString (Mailto m emails) =
    "mailto:"
        ++ String.join "," (List.Nonempty.toList emails)
        ++ Url.Builder.toQuery (toQueryParameters m)


{-| For convenience, you can turn a `Mailto` into an `Html.Attribute` as well
-}
toHref : Mailto -> Html.Attribute msg
toHref =
    Html.Attributes.href << toString
