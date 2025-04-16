import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_force_update_service/core/storage_keys.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._();

  static final instance = FirebaseRemoteConfigService._();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future init() async {
    // Set configuration
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        // TODO: Change duration in production to be for example 1 hour
        minimumFetchInterval: Duration.zero, // for dev
      ),
    );

    // Fetch the values from Firebase Remote Config
    await remoteConfig.fetchAndActivate();

    // Optional: listen for and activate changes to the Firebase Remote Config values
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }

  String getMinimumVersion() {
    try {
      final minimumVersion = remoteConfig.getString(StorageKeys.minmumVersion);
      return minimumVersion;
    } catch (e) {
      log(e.toString());
      return StorageKeys.defaultMinimumVersion;
    }
  }
}
