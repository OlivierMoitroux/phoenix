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
      // https://api.flutter.dev/flutter/material/ThemeData-class.html
      theme: ThemeData(

        // The foreground color for widgets (knobs, text, overscroll edge effect, etc).
        accentColor: Colors.orangeAccent,

        // Used to determine the color of text and icons placed on top of the accent color (e.g. the icons on a floating action button)
        accentColorBrightness: Brightness.dark,

         //Defines the color, opacity, and size of icons.
        accentIconTheme: IconThemeData(color: Colors.white), // size

        // A text theme that contrasts with the accent color.
        accentTextTheme: TextTheme(
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, color: Colors.white),
        ),


        appBarTheme: AppBarTheme(
          color: myColors.orange1,
          textTheme: TextTheme(title:TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
        ),

        // A color that contrasts with the primaryColor, e.g. used as the remaining part of a progress bar.
        backgroundColor: myColors.covoitULiegeColor,

        // The default color of the BottomAppBar
//        bottomAppBarColor: ,// custom,

        // A theme for customizing the shape, elevation, and color of a BottomAppBar.
//        bottomAppBarTheme: ,// custom,


        // The brightness of the overall theme of the application. Used by widgets like buttons to determine what color to pick when not using the primary or accent color
        brightness: Brightness.dark,

        // The default fill color of the Material used in RaisedButtons
        buttonColor: myColors.orange1,

        // Defines the default configuration of button widgets, like RaisedButton and FlatButton.
//        buttonTheme: ,// ButtonThemeData()
//        cardColor: ,
//        cardTheme: ,
//        cursorColor:,
//        dialogBackgroundColor:,
//        dialogTheme:,
        dividerColor: Colors.black54,
        errorColor: Colors.redAccent,
//        floatingActionButtonTheme:,
//        highlightColor:,
//        hintColor: ,
//        iconTheme: ,
//        indicatorColor:,
//        inputDecorationTheme:,
//        materialTapTargetSize:,
//        pageTransitionsTheme:,
//        platform:,
      // The background color for major parts of the app (toolbars, tab bars, etc)
//        primaryColor: Colors.black,
//        primaryColorBrightness:,
      //  A darker version of the primaryColor.
//        primaryColorDark:,
        // A lighter version of the primaryColor.
//        primaryColorLight: ,
//        primaryIconTheme:,
        primaryTextTheme: TextTheme(
          //title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black54),
          body1: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
//        scaffoldBackgroundColor:,
//        sliderTheme:,
//        splashColor:,
//        tabBarTheme:,
//        textSelectionColor:,
//        textSelectionHandleColor: ,
      // Text with a color that contrasts with the card and canvas colors.
//        textTheme: ,

        toggleableActiveColor: Colors.deepOrangeAccent,

        primaryColorDark: myColors.dark,




        // textTheme: TextTheme(),
//        buttonColor: myColors.orange1,
//

      ),
      routes: routing.routes,
    );
  }
}