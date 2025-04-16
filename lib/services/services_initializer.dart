import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_force_update_service/firebase_options.dart';
import 'package:flutter_force_update_service/services/firebase_remote_config_service.dart';

class ServicesInitializer {
  ServicesInitializer._();

  static final ServicesInitializer instance = ServicesInitializer._();

  init() async {
    await _initFirebase();
    await _initFirebaseRemoteConfig();
  }

  _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  _initFirebaseRemoteConfig() async {
    await FirebaseRemoteConfigService.instance.init();
  }
}
