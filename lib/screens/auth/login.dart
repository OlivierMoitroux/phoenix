/*
 * Copyright (C) 2019 Olivier Moitroux - All Rights Reserved
 *
 * Unauthorized copying/distribution of this file, via any medium is strictly
 * prohibited without the express permission of Olivier Moitroux.
 */

import 'package:flutter/material.dart';
import 'package:phoenix/utils/colors.dart';
import 'package:phoenix/utils/alert_box.dart';
import 'package:phoenix/models/login.dart' as login_model;
import 'package:phoenix/network/network_utils.dart';
import 'package:phoenix/store/secured_storage.dart';
import 'dart:convert';
import 'dart:async';
import 'package:crypto/crypto.dart';

/* ======================================================================= *
 *                               Utils
 * ======================================================================= */
/// An enumeration for the submit button state (UI animation)
enum LoginButtonState { standard, inProgress, valid, notValid }

/// Hash password to enhance security (limit data leakage)
String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

/* ======================================================================= *
 *                          Login Page
 * ======================================================================= */
/// First screen seen by the user when opening the app. Login page.
class LoginPage extends StatefulWidget {
  LoginPage({this.onSignedIn});

  // A callback to return status to root_page
  final VoidCallback onSignedIn;

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create an empty LoginData model (will be filled in the form)
  login_model.LoginData _data = new login_model.LoginData.empty();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  LoginButtonState _loginButtonState;

  final int MIN_KEY_LENGTH = 4;

  // Called before build
  @override
  void initState() {
    super.initState();
    // Login button state should be in standard mode by default ("log in")
    _loginButtonState = LoginButtonState.standard;
  }

  /*   ------------------------------------------------------------- *
   *                           Validators
   *   ------------------------------------------------------------- */
  String _validateKey(String key) {
    if (key.length < MIN_KEY_LENGTH) {
      return 'The activation key must be at least ' +
          MIN_KEY_LENGTH.toString() +
          ' characters.';
    }
    return null;
  }

  String _validateUsername(String usr) {
    if (usr.length < 1) {
      return 'Please enter your username.';
    }
    return null;
  }

  /*   ------------------------------------------------------------- *
   *                         Submit button
   *   ------------------------------------------------------------- */
  /// Display a little spinner instead of the "log in" message to notify user that app is querying server
  void animateLogInButton() {
    setState(() {
      _loginButtonState = LoginButtonState.inProgress;
    });
  }

  /// Display in a visual manner the success of a server query
  void displayStateLogInButton(bool success) {
    setState(() {
      _loginButtonState =
          success ? LoginButtonState.valid : LoginButtonState.notValid;
    });
  }

  /// Reset the login button to the message "log in"
  resetStateLogInButton() {
    setState(() {
      _loginButtonState = LoginButtonState.standard;
    });
  }

  /// Logic of a submit request for logging in
  void submit(context) async {
    // Check user inputs are valid and save the form
    if (this._formKey.currentState.validate()) {
      try {
        _formKey.currentState.save();

        // Display splash screen/spinner
        animateLogInButton();

        bool isConnected = await isCo2Internet();

        if (!isConnected) {
          showDialogBox(context, "No internet connection available.",
              "Please turn on wifi or cellular network in your settings.");
        } else {
          // Query server
          ServerReply reply = await NetworkUtilsSingleton.getInstance()
              .logIn(_data.username, _data.password);

          if (reply.isSuccess()) {
            print("[Login] ${json.encode(_data)}");

            // Store login data (session) to secured storage, for later queries
            await SecuredStorageSingleton.getInstance()
                .write(key: "session", value: json.encode(_data));

            displayStateLogInButton(reply.isSuccess());

            // Wait a little bit so that user has time to see the animation
            await new Future.delayed(new Duration(seconds: 1));

            resetStateLogInButton();

            // Root to home page
            widget.onSignedIn();
          } else {
            // Wrong id or password
            displayStateLogInButton(reply.isSuccess());
//            showDialogBox(context, reply.content, "Please try again");

            // Wait a little bit so that user has time to see
//            await new Future.delayed(new Duration(seconds: 1));
//            resetStateLogInButton();
              widget.onSignedIn();
          }
        }
      } catch (e) {
        resetStateLogInButton();
        showDialogBox(context, "Error logging in", "Please try again or later");
        print(e.toString());
      }
      resetStateLogInButton();
    }
  }

  /*   ------------------------------------------------------------- *
   *                                UI
   *   ------------------------------------------------------------- */
  Widget _buildBody() {
    final _logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 68.0,
        child: Image.asset('assets/logos/phoenix_long.png'),
      ),
    );

    final _username = TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: Colors.white,
      ),
      autofocus: false,
      autocorrect: false,
      validator: this._validateUsername,
      onSaved: (String inputUsr) {
        this._data.username = inputUsr;
      },
      decoration: InputDecoration(
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 45,
        ),
        hintText: 'Enter a username',
//        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    /// Form input for password
    final _password = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      autofocus: false,
      obscureText: true,
      autocorrect: false,
      validator: this._validateKey,
      onSaved: (String inputUsr) {
        this._data.password = generateMd5(inputUsr);
      },
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.white,
          size: 45,
        ),
        hintText: 'Enter your activation code',
//        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    Widget _setUpLogInButtonChild() {
      if (_loginButtonState == LoginButtonState.standard) {
        return new Text(
          'Activate',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        );
      } else if (_loginButtonState == LoginButtonState.inProgress) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      } else if (_loginButtonState == LoginButtonState.valid) {
        return Icon(Icons.check, color: Colors.white);
      } else {
        return Icon(Icons.close, color: Colors.white);
      }
    }

    /// Log in button
    final _logInButton = RaisedButton(
      //color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      child: _setUpLogInButtonChild(),
      onPressed: () {
        this.submit(context);
      },
    );

    return new Center(
      child: new Form(
        key: this._formKey,
        child: new ListView(
          padding: EdgeInsets.only(top: 90.0, left: 24.0, right: 24.0),
          children: <Widget>[
            // picture,
            _logo,
            SizedBox(height: 100.0),
            _username,
            SizedBox(height: 16.0),
            _password,
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.info_outline, size: 20.0, color: Colors.white),
                SizedBox(
                  width: 5,
                ),
                new Container(
////                  padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                  width: 200,
                  child: Text(
                      "You can find your activation access in your welcome pack.",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(color: Colors.white70),
                          )),
                ),
              ],
            ),

            SizedBox(height: 48.0),
            _logInButton,
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Form input for username

    return new Scaffold(
//        appBar: new AppBar(
//
//          title: new Text('Login to phoenix'),
//        ),
      body: _buildBody(),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }
}
