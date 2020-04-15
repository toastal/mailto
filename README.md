# mailto

A piped DSL for creating `mailto:` links.

```elm
partnerMailto : Mailto
partnerMailto =
    mailto "partner@test.mail"
        |> subject "I want to cook you dinner"
        |> cc [ "cc@test.mail", "mutualfriend@test.mail" ]
        |> bcc [ "secretfriend@test.mail" ]
        |> body "I’ll be making a spicy, Isaan nam dtok muu salad (น้ำตกหมู)."

view : Html msg
view =
    a
        [ toHref partnerMailto ]
        [ text "🐷🌶️🥬🍚" ]
```

Which will output

```html
<a href="mailto:partner@test.mail?subject=I%20want%20to%20cook%20you%20dinner&cc=cc@test.mail,mutualfriend@test.mail&bcc=secretfriend@test.mail&body=I%E2%80%99ll%20be%20making%20a%20spicy,%20Isaan%20nam%20dtok%20muu%20salad%20(%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%95%E0%B8%81%E0%B8%AB%E0%B8%A1%E0%B8%B9).">"🐷🌶️🥬🍚</a>
```
