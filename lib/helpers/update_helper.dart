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
