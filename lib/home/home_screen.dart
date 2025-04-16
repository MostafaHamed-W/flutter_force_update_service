import 'package:flutter/material.dart';
import 'package:flutter_force_update_service/helpers/update_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UpdateHelper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Force Update Demo'),
        ),
        body: const Center(
          child: Text('Homescreen content here...'),
        ),
      ),
    );
  }
}
