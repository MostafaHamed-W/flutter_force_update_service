# 🔄 Flutter Force Update Service

This repository demonstrates how to implement **dynamic app updates** (forced or optional) using a combination of:

- [`upgrader`](https://pub.dev/packages/upgrader)
- [`firebase_remote_config`](https://pub.dev/packages/firebase_remote_config)

With this setup, you can:
- Dynamically control the **minimum allowed app version** using Firebase Remote Config.
- Display a **customizable update dialog** based on the current and minimum version.
- Enforce a **force update** or allow the user to skip the update — all remotely, without publishing new releases.

---

## 🚀 Features

✅ Check for the latest version on the store (Google Play / App Store).  
✅ Configure the minimum supported version dynamically from Firebase.  
✅ Automatically display a force update dialog if needed.  
✅ Customize buttons, dialog behavior, release notes, and more.  
✅ Works on both **Android** and **iOS**.

---

## 🧠 How It Works

1. **Upgrader** fetches the latest version from the app store and compares it with the current version.
2. **Firebase Remote Config** provides the `minimumVersion` allowed.
3. If the user's version is **below** `minimumVersion`, a **force update** dialog is shown.
4. If the user's version is **above or equal**, an **optional update** dialog can be shown.

---

## 🛠️ Setup

### 1. Add Dependencies

```yaml
dependencies:
  upgrader: ^9.0.0
  firebase_core: ^2.25.4
  firebase_remote_config: ^4.3.11
```




### 2. Initialize Firebase

Make sure you initialize Firebase before using Remote Config.

In your `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```
💡 Make sure you’ve added the required google-services.json (for Android) or GoogleService-Info.plist (for iOS) to your project.




### ⚙️ Step 3: Set Up Firebase Remote Config

Initialize and fetch `Remote Config` to get the `minimumVersion` value from Firebase.

#### 🔧 Create a Remote Config Service

```dart
class FirebaseRemoteConfigService {
  static final FirebaseRemoteConfigService instance = FirebaseRemoteConfigService._();

  late FirebaseRemoteConfig remoteConfig;

  FirebaseRemoteConfigService._();

  Future<void> init() async {
    remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.fetchAndActivate();
  }

  String get minimumVersion => remoteConfig.getString('minimum_version');
}
```

### 🧪 Set Remote Config Key in Firebase Console

1. Go to your Firebase Console > Remote Config.
2. Add a new parameter:
   - Key: `minimum_version`
   - Value: (e.g. `1.0.3`)
3. Publish the changes.

 


 ### 🧩 Step 4: Create the UpdateHelper Widget

Instead of manually handling Upgrader logic inside the `HomeScreen`, we wrap the app with a custom `UpdateHelper` widget. This widget fetches the `minimumVersion` from Firebase Remote Config and injects it into the `Upgrader` instance.

#### 📦 `update_helper.dart`

```dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_force_update_service/core/country_codes.dart';
import 'package:flutter_force_update_service/services/firebase_remote_config_service.dart';
import 'package:flutter_force_update_service/services/navigation_service.dart';
import 'package:upgrader/upgrader.dart';

class UpdateHelper extends StatefulWidget {
  const UpdateHelper({super.key, required this.child});
  final Widget? child;

  @override
  State<UpdateHelper> createState() => _UpdateHelperState();
}

class _UpdateHelperState extends State<UpdateHelper> {
  late Upgrader _upgrader;

  @override
  void initState() {
    final minimumVersion = FirebaseRemoteConfigService.instance.getMinimumVersion();
    log('Minimum Force Update Version: $minimumVersion');
    _upgrader = Upgrader(
      minAppVersion: minimumVersion,
      durationUntilAlertAgain: const Duration(hours: 12),
      countryCode: CountryCodes.sa,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      showReleaseNotes: false,
      navigatorKey: NavigationService.navigationKey,
      dialogStyle: UpgradeDialogStyle.cupertino,
      upgrader: _upgrader,
      child: widget.child,
    );
  }
}
```




### 🧩 Step 5: Use the `UpdateHelper` in Your App

Now that we have the `UpdateHelper` widget set up, the next step is to wrap your app with it in the `main.dart` file or wherever your app's root widget is initialized.

#### 📦 `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_force_update_service/services/firebase_remote_config_service.dart';
import 'package:flutter_force_update_service/update_helper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseRemoteConfigService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Force Update',
      home: const UpdateHelper(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Force Update Example'),
          ),
          body: Center(child: Text('Welcome to the App!')),
        ),
      ),
    );
  }
}
```

✅ The UpdateHelper widget now wraps the Scaffold widget inside MaterialApp, ensuring that it can properly manage dynamic update prompts based on Firebase Remote Config while maintaining other configurations of your app.




### 🔧 Step 6: Run the App

Now that everything is set up, it's time to run your app!

1. Ensure that your Firebase Remote Config is set up with the correct `minimumVersion` value.
2. Make sure the Firebase Remote Config is properly fetched and activated.
3. Once everything is configured, run your app on either an Android or iOS simulator/device.

#### 💡 What should happen:

- When the app launches, the `UpdateHelper` widget checks for the app's version against the minimum version specified in Firebase Remote Config.
- If the user's app version is outdated (below the `minimumVersion`), the upgrade dialog will appear.
- The user can either choose to force update (if the update is mandatory), update later, or ignore the prompt, depending on the Firebase settings.

#### ✅ Test the Force Update:

- You can test the force update by modifying the `minimumVersion` in your Firebase Remote Config.
- Once the value is updated, all users will receive the updated behavior the next time they open the app, without needing to release a new version of the app.
