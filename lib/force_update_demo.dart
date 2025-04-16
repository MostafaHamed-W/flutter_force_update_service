import 'package:flutter/material.dart';
import 'package:flutter_force_update_service/home/home_screen.dart';
import 'package:flutter_force_update_service/services/navigation_service.dart';

class ForceUpdateDemo extends StatelessWidget {
  const ForceUpdateDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigationKey,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
