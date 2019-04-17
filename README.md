# mailto

A piped DSL for creating `mailto:` links.

```elm
partnerMailto : Mailto
partnerMailto =
    mailto "partner@test.mail"
        |> subject "I want to cook you dinner"
        |> cc [ "cc@test.mail", "mutualfried@test.mail" ]
        |> bcc [ "secretfriend@test.mail" ]
        |> body "It will be a spicy nam dtok muu salad."

view : Html msg
view =
    a
        [ toHref partnerMailto ]
        [ text "🐷🌶️🥬🍚" ]
```

Which will output

```html
<a href="mailto:partner@test.mail?subject=I want to cook you dinner&cc=cc@test.mail,mutualfried@test.mail&bcc=secretfriend@test.mail&body=It will be a spicy nam dtok muu salad.">"🐷🌶️🥬🍚</a>
```
