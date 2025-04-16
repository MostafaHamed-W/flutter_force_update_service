import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static get context => navigationKey.currentState?.context;
}
