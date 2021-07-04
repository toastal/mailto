# mailto

A piped DSL for creating `mailto:` links. See more at [rfc6068](https://datatracker.ietf.org/doc/html/rfc6068#section-4).

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

---

## Project & Community Notes

This project is regrettably available on [GitHub](https://github.com/toastal/mailto). The Elm community has tied itself to the closed-source, Microsoft-owned code forge of GitHub for package registry and identity. This does not protect the privacy or freedom of its community members.

---

## License

This project is licensed under Apache License 2.0 - [LICENSE](./LICENSE) file for details.

## Funding

If you want to make a small contribution to the maintanence of this & other projects

- [Liberapay](https://liberapay.com/toastal/)
- [Bitcoin: `39nLVxrXPnD772dEqWFwfZZbfTv5BvV89y`](link:bitcoin://39nLVxrXPnD772dEqWFwfZZbfTv5BvV89y?message=Funding%20toastal%E2%80%99s%20Elm%20mailto%20development
) (verified on [Keybase](https://keybase.io/toastal/sigchain#690220ca450a3e73ff800c3e059de111d9c1cd2fcdaf3d17578ad312093fff2c0f))
- [Zcash: `t1a9pD1D2SDTTd7dbc15KnKsyYXtGcjHuZZ`](link:zcash://t1a9pD1D2SDTTd7dbc15KnKsyYXtGcjHuZZ?message=Funding%20toastal%E2%80%99s%20Elm%20mailto%20development) (verified on [Keybase](https://keybase.io/toastal/sigchain#65c0114a3c8ffb46e39e4d8b5ee0c06c9eb97a02c4f6c42a2b157ca83b8c47c70f))
