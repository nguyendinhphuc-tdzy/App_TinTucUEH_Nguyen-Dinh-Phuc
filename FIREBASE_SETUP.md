# Firebase Cloud Messaging — UEH Student (Android)

The app code now includes `firebase_core`, `firebase_messaging`,
`flutter_local_notifications`, an Android notification channel and SQLite
history. **FCM is not active until you configure your own Firebase project.**

## 1. Create Firebase project

Open https://console.firebase.google.com and create a project, e.g.
`UEHStudent`. This does not replace the existing Student API login.

## 2. Install CLIs (Windows PowerShell)

```powershell
node --version
npm --version
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```

If `flutterfire` is not on PATH, add
`%LOCALAPPDATA%\\Pub\\Cache\\bin` to PATH, or use:
`dart pub global run flutterfire_cli:flutterfire configure`.

## 3. Connect the correct Android app

From your Flutter project root:

```powershell
git pull origin main
flutter pub get
flutterfire configure --platforms=android
```

Choose your Firebase project. The Android package name in the current repo is
`com.example.flutter_application_1` (see
`android/app/build.gradle.kts`). Do not choose a different package
without changing the Android configuration first.

The FlutterFire CLI generates `lib/firebase_options.dart` and Android
Firebase resources and may configure the Google Services Gradle plugin.
**Do not hand-write Firebase project credentials or placeholder files.**
FlutterFire's documented preferred initialization uses
`DefaultFirebaseOptions.currentPlatform`. The current Android-only code
uses `Firebase.initializeApp()`, which uses the configured native Android
Firebase resources and is safe to run before configuration: if not configured,
only the notification module reports an error.

If the CLI did not configure Google Services, review its terminal output and
the official https://firebase.google.com/docs/flutter/setup guide before
proceeding. Do not push Firebase service-account private keys or passwords.

## 4. Android permissions and Gradle

The repo already includes `POST_NOTIFICATIONS`,
`default_notification_channel_id`, and Java core library desugaring.
Use **Android** for FCM tests (not Windows desktop or Chrome).

```powershell
flutter analyze
flutter test
flutter run -d emulator-5554
```

On Android 13+, open the **Thông báo** tab and tap
**Cho phép thông báo**. On an Android emulator use a Google Play-enabled
system image with working Google Play services, or use a physical Samsung.

## 5. Send a Firebase Console test

In the app's Notifications tab tap **Sao chép FCM token**.
Do not paste this device token into public chat or commit it to GitHub.

Firebase Console -> Messaging -> Create campaign / Notification message ->
**Send test message**, paste the token, click Test.

- With the app **foreground**: app shows a local notification and writes SQLite.
- With the app **background**: Android FCM displays notification automatically;
  the background callback/tap handler persists the message in SQLite where
  supported. Reopen the app and visit Notifications.
- If no message arrives, check granted notification permission, Firebase
  project ID, Android app package, Google Play services and CLI configuration.

Notification history lives on the device in `ueh_notifications.db` and is
limited to the newest 200 records in the UI. This does **not** upload FCM
tokens to the Student API: the supplied API Guide has no token registration
endpoint. Sending to specific students/classes requires a trusted server
and an approved token-to-user mapping. Never put a Firebase service-account
private key in Flutter source or Postman public collections.

## Troubleshooting

- `Firebase chưa được liên kết`: run `flutterfire configure --platforms=android`
  then **full restart**, not hot reload.
- `gradle ... Read timed out`: unstable Google Maven download; retry on a
  reliable network.
- Notification permission `denied`: Settings -> Apps -> UEH Student ->
  Notifications -> Allow.
- The Android emulator is unstable: test on your Samsung instead.

Official references:
- https://firebase.google.com/docs/flutter/setup
- https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages
- https://pub.dev/packages/flutter_local_notifications
