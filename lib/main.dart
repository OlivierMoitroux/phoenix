import 'package:flutter/material.dart';

import 'package:phoenix/root_widget.dart';
import 'package:phoenix/utils/colors.dart' as myColors;
import 'package:phoenix/routing.dart' as routing;
import 'package:phoenix/utils/theme.dart' as myTheme;

/// This is the main entry point of the application
///
/// *To compile the app:* flutter build apk --debug
void main() {
  runApp(new PhoenixApp());
}

/// Main entry point of code. Initialise a RootPage.<br>
/// Define themes and colors here
class PhoenixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Phoenix rental',
      home: new RootPage(),
      // https://api.flutter.dev/flutter/material/ThemeData-class.html
      theme: myTheme.myThemeData,
      debugShowCheckedModeBanner: false,
      routes: routing.routes,
    );
  }
}

