import 'package:flutter/material.dart';

import 'package:phoenix/root_widget.dart';
import 'package:phoenix/utils/colors.dart' as myColors;
import 'package:phoenix/routing.dart' as routing;


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
      title: 'Phoenix RE',
      home: new RootPage(),
      theme: ThemeData(
        backgroundColor: myColors.covoitULiegeColor,
        textTheme: TextTheme(
            body1: TextStyle(color: Colors.black54)
        ),
        buttonColor: myColors.covoitULiegeColor,
        dividerColor: Colors.black54,

      ),
      routes: routing.routes,
    );
  }
}