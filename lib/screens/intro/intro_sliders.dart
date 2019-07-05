/*
 * Copyright (C) 2019 Olivier Moitroux - All Rights Reserved
 *
 * Unauthorized copying/distribution of this file, via any medium is strictly
 * prohibited without the express permission of Olivier Moitroux.
 */

import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:phoenix/screens/auth/login.dart';
import 'package:phoenix/utils/colors.dart' as myColors;


class IntroScreen extends StatefulWidget {

  IntroScreen({@required this.onSignedIn});


  // A callback to return status to root_page
  final VoidCallback onSignedIn;

//  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();
  bool dispSlides = true;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Welcome home !",
        description: "This application is designed to help you enjoy the most your stay in Marbella.",
        pathImage: "assets/images/photo_eraser.png",
        backgroundColor: myColors.dark,
      ),
    );
    slides.add(
      new Slide(
        title: "How can I use this app ?",
        description: "Features include list of tutorials and services, recommended restaurants and activities in the region.",
        pathImage: "assets/images/photo_pencil.png",
        backgroundColor: myColors.dark,
      ),
    );
    slides.add(
      new Slide(
        title: "Let's activate your access rights !",
        description:
        "You will be asked to enter a username as well as the activation code you can find in your welcome pack.",
        pathImage: "assets/images/photo_ruler.png",
        backgroundColor: myColors.dark,
      ),
    );
  }

  /// Call back when tutorial is done
  void onDonePress() {

//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => LoginPage(
//        onSignedIn: widget.onSignedIn,
//      )),
//    );

  setState(() {
    dispSlides = false;
  });
  }

  @override
  Widget build(BuildContext context) {
    if (dispSlides){
      return new IntroSlider(
        slides: this.slides,
        onDonePress: this.onDonePress,
      );
    }
    else {
      return new LoginPage(
        onSignedIn: widget.onSignedIn,
      );
    }

  }
}