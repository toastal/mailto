module Mailto exposing
    ( Mailto
    , Email
    , mailto, mailtoMultiple, mailtoEmpty
    , subject, cc, bcc, body
    , toString, toHref
    )

{-| A small DSL to build Mailto links


# Definition

@docs Mailto


# Alias

@docs Email


# Creation

@docs mailto, mailtoMultiple, mailtoEmpty


# Adding fields

@docs subject, cc, bcc, body


# Formats

@docs toString, toHref

-}

import Endo exposing (Endo, Over)
import Html
import Html.Attributes
import Url.Builder exposing (QueryParameter)


{-| Just a `String` alias
-}
type alias Email =
    String


type alias EmailAttrs =
    { subject : Maybe String
    , cc : List Email
    , bcc : List Email
    , body : Maybe String
    }


emptyEmailAttrs : EmailAttrs
emptyEmailAttrs =
    { subject = Nothing
    , cc = []
    , bcc = []
    , body = Nothing
    }


toQueryParameters : EmailAttrs -> List QueryParameter
toQueryParameters attrs =
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
        [ Maybe.map (Url.Builder.string "subject") attrs.subject
        , copyTo "cc" attrs.cc
        , copyTo "bcc" attrs.bcc
        , Maybe.map (Url.Builder.string "body") attrs.body
        ]


{-| Definition
-}
type Mailto
    = Mailto EmailAttrs (List Email)


{-| Constructs an empty Mailto with no parameters. It’s the `singleton` of `Mailto`.
-}
mailto : Email -> Mailto
mailto =
    mailtoMultiple << List.singleton


{-| Constructs an empty Mailto with no parameters, but with mailtoMultiple recipients. It’s the `singleton` of `Mailto`.
-}
mailtoMultiple : List Email -> Mailto
mailtoMultiple =
    Mailto emptyEmailAttrs


{-| Constructs an empty Mailto with no parameters, but has no email addresses (useful when you want a blank message template). It’s the `singleton` to `Mailto`.
-}
mailtoEmpty : Mailto
mailtoEmpty =
    mailtoMultiple []


over : Over Mailto EmailAttrs
over f (Mailto attrs email) =
    Mailto (f attrs) email


{-| Adds a subject to the mailto

    mailto "partner@test.mail"
        |> subject "I want to cook you dinner"
        |> toString
    -- "mailto:partner@test.mail?subject=I%20want%20to%20cook%20you%20dinner"

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
        |> body "I’ll be making a spicy, Isaan nam dtok muu salad (น้ำตกหมู)."
        |> toString
    -- "mailto:partner@test.mail?body=I%E2%80%99ll%20be%20making%20a%20spicy,%20Isaan%20nam%20dtok%20muu%20salad%20(%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%95%E0%B8%81%E0%B8%AB%E0%B8%A1%E0%B8%B9)."

-}
body : String -> Endo Mailto
body body_ =
    over (\m -> { m | body = Just body_ })


{-| After composing a `Mailto`, consume a string
-}
toString : Mailto -> String
toString (Mailto m emails) =
    "mailto:"
        ++ String.join "," emails
        ++ Url.Builder.toQuery (toQueryParameters m)


{-| For convenience, you can turn a `Mailto` into an `Html.Attribute` as well
-}
toHref : Mailto -> Html.Attribute msg
toHref =
    Html.Attributes.href << toString
