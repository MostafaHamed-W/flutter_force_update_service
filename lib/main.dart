import 'package:flutter/material.dart';
import 'package:flutter_force_update_service/force_update_demo.dart';
import 'package:flutter_force_update_service/services/services_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServicesInitializer.instance.init();
  runApp(const ForceUpdateDemo());
}
