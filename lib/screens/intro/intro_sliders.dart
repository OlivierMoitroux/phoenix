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
        maxLineTitle: 2,
        description: "This application is your new companion and is designed to help you enjoy the most your stay in Marbella.",
        pathImage: "assets/icons/home-interface.png",
        backgroundColor: myColors.dark,
      ),
    );
    slides.add(
      new Slide(
        title: "How can you use this app ?",
        maxLineTitle: 2,
        description: "Features include \n - Tutorials about home appliances\n - List of services\n - Recommended restaurants\n - Recommended activities in the region.",
        pathImage: "assets/icons/puzzle.png",
        backgroundColor: myColors.dark,
      ),
    );
    slides.add(
      new Slide(
        title: "Let's activate your access !",
        maxLineTitle: 2,
        description:
        "You will be asked to enter your access information (which you can find in your welcome pack).",
        pathImage: "assets/icons/rocket.png",
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
        styleNameSkipBtn: TextStyle(color: myColors.orange3),
        styleNameDoneBtn: TextStyle(color: myColors.orange3),
        colorActiveDot: myColors.orange3,
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