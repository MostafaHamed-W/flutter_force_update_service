import 'package:flutter/material.dart';
import 'package:flutter_force_update_service/home/home_screen.dart';

class ForceUpdateDemo extends StatelessWidget {
  const ForceUpdateDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
