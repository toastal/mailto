module Mailto exposing
    ( Mailto
    , Email
    , mailto, mailtoMultiple
    , withSubject, withCc, withBcc, withBody
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

@docs withSubject, withCc, withBcc, withBody


# Formats

@docs toString, toHref

-}

import Html
import Url.Builder exposing (QueryParameter)


type alias Endo a =
    a -> a


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
                    Url.Builder.string key (String.join "," emails)
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
    = Mailto M Email


{-| Constructs an empty Mailto with no parameters. It's the `singleton` of `Mailto`.
-}
mailto : Email -> Mailto
mailto =
    Mailto emptyM


{-| Constructs an empty Mailto with no parameters, but with mailtoMultiple recipients. It's the `singleton` of `Mailto`.
-}
mailtoMultiple : List Email -> Mailto
mailtoMultiple =
    mailTo << String.join ","


mapMailtoM : Endo Mailto
mapMailtoM f (Mailto m email) =
    Mailto (f m) email


{-| Adds a subject to the mailto

    mailto "partner@test.mail"
        |> withSubject "I want to cook you dinner"
        |> toString
    -- "mailto:partner@test.mail?subject=I want to cook you dinner"

-}
withSubject : String -> Endo Mailto
withSubject subject =
    mapMailtoM (\m -> { subject = Just subject })


{-| Adds carbon copies to the mailto

    mailto "partner@test.mail"
        |> withCc [ "cc@test.mail", "mutualfried@test.mail" ]
        |> toString
    -- "mailto:partner@test.mail?cc=cc@test.mail,mutualfried@test.mail"

-}
withCc : List Email -> Endo Mailto
withCc cc =
    mapMailtoM (\m -> { cc = cc })


{-| Adds blind carbon copies to the mailto

    mailto "partner@test.mail"
        |> withBcc [ "bcc@test.mail", "secretfriend@test.mail" ]
        |> toString
    -- "mailto:partner@test.mail?bcc=bcc@test.mail,secretfriend@test.mail"

-}
withBcc : List Email -> Endo Mailto
withBcc bcc =
    mapMailtoM (\m -> { bcc = bcc })


{-| Adds a body to the mailto

    mailto "partner@test.mail"
        |> withBody "It will be spicy nam dtok muu salad."
        |> toString
    -- "mailto:partner@test.mail?body=It will be spicy nam dtok muu salad."

-}
withBody : List String -> Endo Mailto
withBody body =
    mapMailtoM (\m -> { body = Just body })


{-| After composing a `Mailto`, consume a string
-}
toString : Mailto -> String
toString (Mailto email m) =
    "mailto:" ++ email ++ Url.Builder.toQuery (toQueryParameters m)


{-| For convenience, you can turn a `Mailto` into an `Html.Attribute` as well\`
-}
toHref : Mailto -> Html.Attribute msg
toHref =
    Html.Attribute.href << toString
