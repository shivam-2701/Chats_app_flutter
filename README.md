# ChatsApp Flutter

Clone of WhatsApp with personal and global chat support.

## Info

This project uses Firebase under-the-hood-

- Cloud Firestore
- Firebase Auth
- Firebase Storage

## Showcase

<div style = "display:grid; grid-template-columns:repeat(3,1fr); gap:50px;">
<img src = "https://user-images.githubusercontent.com/105339885/227755997-700137d6-9f1d-4a05-a787-08a454249617.jpg" width="30%"/>
<img src = "https://user-images.githubusercontent.com/105339885/227756005-5755c1e9-fdd2-41e8-95f0-fed212d6ec61.jpg" width="30%"/>
<img src = "https://user-images.githubusercontent.com/105339885/227756015-365388a4-238e-4585-b2fd-4f48a6ad96dc.jpg" width="30%"/>
<img src = "https://user-images.githubusercontent.com/105339885/227756027-e99a3766-5467-4fed-bec5-ecfaef3a62d8.jpg"  width="30%"/>
<img src = "https://user-images.githubusercontent.com/105339885/227756036-c3e73359-582c-44d6-8963-0507369e74b1.jpg" width="30%"/>
</div>

---

### High refresh rate support

This project uses the `flutter_displaymode` plugin (https://pub.dev/packages/flutter_displaymode)

> App by-default prefers the highest available refresh rate

---

## Building and Developing

Config files of Firebase have been removed, to ensure the integrity of underlying backend, but if you want to build or improve the app, you should follow the steps from the official Firebase Documentation to initialize a fresh firebase project in this repo.

> https://firebase.google.com/docs/flutter/setup?platform=android

Initialization will change the `/android` and `/ios` folders as well as add a `firebase_options.dart` in the `/lib` directory of the project.

> You will need to create a new Firebase project under your Google Account to follow through.
