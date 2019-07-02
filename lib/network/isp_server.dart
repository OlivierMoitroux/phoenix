import 'package:phoenix/network/network_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phoenix/store/secured_storage.dart';
import 'package:phoenix/models/login.dart';
import 'package:phoenix/models/register.dart';
import 'dart:convert';

/* ======================================================================= *
 *                          MyNetworkUtils
 * ======================================================================= */

/// An implementation of the BaseNetworkUtils with the [keep calm and stay polite here] CentOs machine provided by the University.
class MyNetworkUtils implements BaseNetworkUtils{

  bool verbose = true;
  bool useHTTPS = true;
  String portNo;

  MyNetworkUtils(){
    BaseNetworkUtils.TIME_OUT = 10; // 5 seconds can be too few sometimes.
    portNo = (useHTTPS?"443":"80");
  }

  /*   ------------------------------------------------------------- *
   *                     Specific to this class
   *   ------------------------------------------------------------- */

  /// Generic method to postData
  /// Use current session stored on disk in header<br>
  ///
  ///   * @param ``jsonStrBody``,  body to send (json string),
  ///   * @param ``url`` url to send
  ///   * @param ``useSession`` Wether to send the current session in headers or not
  ///   * @return <status_code, body> where status_code is the one replied by server,
  ///         body its content
  Future<http.Response> _postData(String jsonStrBody, String url, bool useSession) async {
    http.Response response;

    String session = await SecuredStorageSingleton.getSession();

    if (useSession) {
      if (session == null) {
        print("[_postData] Error async: session not yet retrieve from memory !");
        return http.Response("User session does not exist", -1);
      }
      else {
        if (useHTTPS){
          response = await http.post(
              new Uri.https("spem3.montefiore.ulg.ac.be:" + portNo, url),
              headers: {
                "Content-Type": "application/json",
                "Authorization": session
              },
              body: jsonStrBody).timeout(
              new Duration(seconds: BaseNetworkUtils.TIME_OUT));
        }
        else{
          response = await http.post(
              new Uri.http("spem3.montefiore.ulg.ac.be:" + portNo, url),
              headers: {
                "Content-Type": "application/json",
                "Authorization": session
              },
              body: jsonStrBody).timeout(
              new Duration(seconds: BaseNetworkUtils.TIME_OUT));
        }
      }
    }
    else{
      if (useHTTPS){
        response = await http.post(
            new Uri.https("spem3.montefiore.ulg.ac.be:"+portNo, url),
            headers: {"Content-Type": "application/json"},
            body: jsonStrBody).timeout(new Duration(seconds: BaseNetworkUtils.TIME_OUT));
      }
      else{
        response = await http.post(
            new Uri.http("spem3.montefiore.ulg.ac.be:"+portNo, url),
            headers: {"Content-Type": "application/json"},
            body: jsonStrBody).timeout(new Duration(seconds: BaseNetworkUtils.TIME_OUT));
      }
    }
    if (verbose && response != null){
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }

    return response;
  }


  /// Generic method to getData
  /// Use current session stored on disk in header<br>
  ///
  ///   * @param ``jsonStrBody``,  body to send (json string),
  ///   * @param ``url`` url to send
  ///   * @return <status_code, body> where status_code is the one replied by server,
  ///         body its content
  ///   NB: not used due to server API
  Future<http.Response> _getData(String jsonStrBody, String url) async {
    http.Response response;

    String session = await SecuredStorageSingleton.getSession();


    if (session == null) {
      print("[_postData] Error async: session not yet retrieve from memory !");
      return http.Response("User session does not exist", -1);
    }

    if (useHTTPS){
      response = await http.get(
          new Uri.https("spem3.montefiore.ulg.ac.be:" + portNo, url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": session
          }).timeout(
          new Duration(seconds: BaseNetworkUtils.TIME_OUT));
    }
    else {
      response = await http.get(
        new Uri.http("spem3.montefiore.ulg.ac.be:" + portNo, url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": session
        },
      ).timeout(new Duration(seconds: BaseNetworkUtils.TIME_OUT));
    }
    return response;
  }


  /*   ------------------------------------------------------------- *
   *                     Bug Reporting
   *   ------------------------------------------------------------- */

  /// Send the content of the collected logs to the provided email address
  bool sendLogs(String email) {
    return false;
  }


  /*   ------------------------------------------------------------- *
   *               Get information from server
   *   ------------------------------------------------------------- */

  /// Get the information of the account of the user. <br>
  /// *Not implemented*
  Future<ServerReply> getAccountData() async{
    return ServerReply(false, "Feature not implemented");
  }

  /// Get a token from server<br>
  /// *Not implemented*
  Future<ServerReply> getToken() async {
    return ServerReply(false, "Feature not implemented"); // (on advice of client)
  }

  /// By default, we make one-shot connection, no session memory when
  /// the app is shutdown
  bool isLoggedIn(){
    return false;
  }


  Future<ServerReply> getInitConfig() async{
    try {
      http.Response reply = await _postData(json.encode("GetConfig"), "/GetConfig", true);
      if (verbose) {
        print("[getInitConfig] Response status: ${reply.statusCode}");
        print("[getInitConfig] Response body: ${reply.body}");
      }

      if (reply.statusCode == 200) {
        return ServerReply(true, reply.body);
      }
      if (reply.statusCode >= 500)
        return ServerReply(false, "Server is not available");

      return ServerReply(false, reply.body);
    }
    catch(e){
      print("[postData] trigger exception: $e");
      return ServerReply(false, "Server does not respond");
    }
  }


  /*   ------------------------------------------------------------- *
   *                      Authentification
   *   ------------------------------------------------------------- */

  /// Logout
  Future<ServerReply> logout() async {
    // Nothing to send to server, otherwise, goes here
    return ServerReply(true, "");
  }

  /// Login
  Future<ServerReply> logIn(String username, String pswd) async {
    LoginData loginData = LoginData.empty();
    loginData.username = username;
    loginData.password = pswd;

    //Conversion of data into json.
    String jsonStringLoginData = json.encode(loginData);
    print(jsonStringLoginData);

    try {
      http.Response reply = await _postData(jsonStringLoginData, "/Login", false);
      if (verbose){
        print("[logIn] Response status: ${reply.statusCode}");
        print("[logIn] Response body: ${reply.body}");
      }
      if (reply.statusCode == 200)
        return ServerReply(true, reply.body);

      if (reply.statusCode >= 500)
        return ServerReply(false, "Server is not available");

//      return ServerReply(false, "Wrong ID or password");
      return ServerReply(false, reply.body);

    } catch (e) {
      if(verbose) print(e);
      return ServerReply(false, "Server currently unavailable");
    }
  }


  /*   ------------------------------------------------------------- *
   *                   Sending data collected
   *   ------------------------------------------------------------- */

/*   ------------------------------------------------------------- *
   *                 Account management and GDPR stuffs
   *   ------------------------------------------------------------- */

  /// Delete from server the habits inferred from the user collected data
  Future<ServerReply> deleteRemoteData() async {
    try {
      http.Response reply = await _postData(json.encode("DeleteData"), "/DeleteData", true);
      if (verbose) {
        print("[deleteRemoteHabits] Response status: ${reply.statusCode}");
        print("[deleteRemoteHabits] Response body: ${reply.body}");
      }

      if (reply.statusCode == 200) {
        return ServerReply(true, reply.body);
      }
      if (reply.statusCode >= 500)
        return ServerReply(false, "Server is not available");

      return ServerReply(false, reply.body);

    } catch (e) {
      print("[postData] trigger exception: $e");
      return ServerReply(false, "Server does not respond");
    }
  }

  /// Delete the account of a user and the associated data
  Future<ServerReply> deleteAccount() async {
    try {
      http.Response reply = await _postData(json.encode("DeleteAccount"), "/DeleteAccount", true);
      if (verbose) {
        print("[deleteAccount] Response status: ${reply.statusCode}");
        print("[deleteAccount] Response body: ${reply.body}");
      }

      if (reply.statusCode == 200) {
        return ServerReply(true, reply.body);
      }
      if (reply.statusCode >= 500)
        return ServerReply(false, "Server is not available");

      return ServerReply(false, reply.body);
    } catch (e) {
      print("[postData] trigger exception: $e");
      return ServerReply(false, "Server does not respond");
    }
  }

  /// Fetch all the user data stored on the server
  Future<ServerReply> downloadUserData() async {
    try {
      http.Response reply = await _postData(json.encode("DownloadUserData"), "/DownloadUserData", true);
      if (verbose) {
        print("[deleteAccount] Response status: ${reply.statusCode}");
        print("[deleteAccount] Response body: ${reply.body}");
      }

      if (reply.statusCode == 200) {
        return ServerReply(true, reply.body);
      }
      if (reply.statusCode >= 500)
        return ServerReply(false, "Server is not available");

      return ServerReply(false, reply.body);
    } catch (e) {
      print("[postData] trigger exception: $e");
      return ServerReply(false, "Server does not respond");
    }
  }


}