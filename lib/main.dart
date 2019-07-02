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
      title: 'Phoenix rental',
      home: new RootPage(),
      theme: ThemeData(
        backgroundColor: myColors.mainColor,
        accentColor: Colors.cyan[600],

        textTheme: TextTheme(
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.black54),
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black54),
            body1: TextStyle(fontSize: 14.0, color: Colors.black54),

        ),
        buttonColor: myColors.mainColor,
        dividerColor: Colors.black54,

      ),
      routes: routing.routes,
    );
  }
}