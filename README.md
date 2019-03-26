# mailto

A piped DSL for creating `mailto:` links.

```elm
partnerMailto : Mailto
partnerMailto =
    mailto "partner@test.mail"
        |> withSubject "I want to cook you dinner"
        |> withCc [ "cc@test.mail", "mutualfried@test.mail" ]
        |> withBcc [ "secretfriend@test.mail" ]
        |> withBody "It will be spicy nam dtok muu salad."

view : Html msg
view =
    a
        [ toHref partnerMailto ]
        [ text "🐷🌶️🥬🍚" ]
```

Which will output

```html
<a href="mailto:partner@test.mail?subject=I want to cook you dinner&cc=cc@test.mail,mutualfried@test.mail&bcc=secretfriend@test.mail&body=It will be spicy nam dtok muu salad.">"🐷🌶️🥬🍚</a>
```
