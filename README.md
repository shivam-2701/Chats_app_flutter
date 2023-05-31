# ChatsApp Flutter

Clone of WhatsApp with personal and global chat support.

## Info

This project uses Firebase under-the-hood-

- Cloud Firestore
- Firebase Auth
- Firebase Storage



### High refresh rate support

This project uses the `flutter_displaymode` plugin (https://pub.dev/packages/flutter_displaymode)

> App by-default prefers the highest available refresh rate

---

## Building and Developing

Config files of Firebase have been removed, to ensure the integrity of underlying backend, but if you want to build or improve the app, you should follow the steps from the official Firebase Documentation to initialize a fresh firebase project in this repo.

> https://firebase.google.com/docs/flutter/setup?platform=android

Initialization will change the `/android` and `/ios` folders as well as add a `firebase_options.dart` in the `/lib` directory of the project.

> You will need to create a new Firebase project under your Google Account to follow through.
