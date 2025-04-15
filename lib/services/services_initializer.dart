import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_force_update_service/firebase_options.dart';

class ServicesInitializer {
  ServicesInitializer._();

  static final ServicesInitializer servicesInitializer = ServicesInitializer._();

  init(WidgetsBinding widgetsBinding) async {
    //Init FirebaseApp instance before runApp
    await _initFirebase();
    widgetsBinding.deferFirstFrame();
    widgetsBinding.addPostFrameCallback((_) async {
      //Run any function you want to wait for before showing app layout
      await _initializeServices();
    });
  }

  _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future _initializeServices() async {}
}
