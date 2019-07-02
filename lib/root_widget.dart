import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:phoenix/network/network_utils.dart';
import 'package:phoenix/store/secured_storage.dart';
import 'package:phoenix/screens/auth/login.dart';
import 'package:phoenix/screens/home/home.dart';

/// --------------------------------------------------------------------------
///                         Configuration
///                         *************
/// --------------------------------------------------------------------------

//final Map<String, dynamic> DEFAULT_CONFIG = {"Example":1};


/// --------------------------------------------------------------------------
///                         Widget tree
///                         ************
/// --------------------------------------------------------------------------

/// Root page act as an intermediate widget between the login and the home screen
class RootPage extends StatefulWidget{

  RootPage();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

/// Used to root to home or login according to the user status
enum AuthStatus{
  notLoggedIn,
  loggedIn
}

/// Most important widget of the app. It is initialized by main().
/// If the user is not logged in, this page root to the login page.
/// Upon receiving a valid connection status, this page is called back to root to home page. At the same time, it launches the background process and control its logic.
class _RootPageState extends State<RootPage> {

  // By default, the app root to the login form.
  AuthStatus authStatus = AuthStatus.notLoggedIn;


//  Map<String, dynamic> CONFIG;


  _RootPageState();

  @override
  void initState(){
    super.initState();
    setState(() {
      // If we want to make the connect persistent, change this, so that it does not return
      // always false but check session in memory with a token with limitied lifetime
      // (expiration associated with possibility to extend it if app is still being used)
      authStatus = NetworkUtilsSingleton.getInstance().isLoggedIn()?AuthStatus.loggedIn:AuthStatus.notLoggedIn;
    });
  }

  /// Call this when you get the callback of login_page and user signed in
  void _signedIn() async{

//    // Get remote configuration of the app from the server
//    ServerReply configReply = await NetworkUtilsSingleton.getInstance().getInitConfig();
//    if (configReply.isSuccess()) {
//      CONFIG = json.decode(configReply.content);
//    }
//    else{
//      CONFIG = DEFAULT_CONFIG;
//      print("Error downloading config from server -> default set\n\n${configReply.content}");
//    }


//    await _fetchRemoteData();

    setState((){
      print("[root_page] Root to home");
      authStatus = AuthStatus.loggedIn;
    });
  }

  void _signedOut(){
    NetworkUtilsSingleton.getInstance().logout();
    SecuredStorageSingleton.getInstance().deleteAll();
    setState((){
      authStatus = AuthStatus.notLoggedIn;
    });
  }

  /// --------------------------------------------------------------------------
  ///                         App configuration methods
  ///                         *****************************
  /// --------------------------------------------------------------------------


  Future<void> _fetchRemoteData() async {
   return;
  }


  /// --------------------------------------------------------------------------
  ///                        UI (root to proper widget)
  ///                        **************************
  /// --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context){
    switch(authStatus){
      case AuthStatus.notLoggedIn:
      // Go to login then
        return new LoginPage(
          onSignedIn: _signedIn,
        );
      case AuthStatus.loggedIn:
      // Go to home then
        return new HomeScreen(
          //onSignedOut: _signedOut,
        );
    }
    return new LoginPage();
  }
}