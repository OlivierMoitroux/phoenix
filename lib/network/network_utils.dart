import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:phoenix/network/isp_server.dart';



/* ======================================================================= *
 *                      Connectivity to internet state
 * ======================================================================= */

/// Return "cellular", "wifi" or "none"
Future<String> getInternetCoMean() async {
  ConnectivityResult mean = await (Connectivity().checkConnectivity());
  if (mean == ConnectivityResult.mobile) {
    return "cellular";
  } else if (mean == ConnectivityResult.wifi) {
    return "wifi";
  } else{
    return "none";
  }
}

Future<bool> isCo2Internet() async {
  ConnectivityResult mean = await Connectivity().checkConnectivity();
  return (mean==ConnectivityResult.wifi)||(mean==ConnectivityResult.mobile);
}

/* ======================================================================= *
 *                          NetworkUtilsSingleton
 * ======================================================================= */

/// A singleton to access the network utility of this app
class NetworkUtilsSingleton {
  // Change instantiation here the day you want to use another server (Firebase, ...)
  static final BaseNetworkUtils _singleton = new MyNetworkUtils();

  NetworkUtilsSingleton();

  static BaseNetworkUtils getInstance() {
    return _singleton;
  }
}

/// Wrapper of the http.Response used in the app code. <br>
/// ```success``` is true/false upon success or not
/// ```content``` is the reply content of the server.
/// In case of error, it contains the error message, possibly filter or processed to be more human readable.
class ServerReply {
  bool success;
  String content;
  ServerReply(this.success, this.content);

  bool isSuccess() => success;
}


/* ======================================================================= *
 *                         BaseNetworkUtils
 * ======================================================================= */

/// Abstract class to define the methods a given server api needs to respect to communicate with this app
abstract class BaseNetworkUtils {

  // default timeout in seconds
  static int TIME_OUT = 10;

  /// Return user status (e.g. is token still valid ?)
  bool isLoggedIn();

  /// Sends logs of the app to ```email``` and launch web mail client of user.
  bool sendLogs(String email);

  /// Log in on server<br>
  /// @return <success, content> where content is the error string if an error
  ///         occured or the token given back by server if any
  Future<ServerReply> logIn(String username, String pswd);

  /// Logout from server
  /// @return <success, content> where content is the error string if an error
  ///         occured, otherwise empty.
  Future<ServerReply> logout();

  /// Request new token
  /// @return <success, content> where content is the error string if an error
  ///         occured, or the token given back by server
  Future<ServerReply> getToken();

  /// Getter for account information (work address, ...)
  /// @return <success, content> where content is the error string if an error
  ///         occured, or the account data structure of this app filled.
  Future<ServerReply> getAccountData();

  /// Delete the habits stored in the server database for this user
  /// @return <success, content> where content is the error string if an error
  ///         occured
  Future<ServerReply> deleteRemoteData();

  /// Ask server to get the configuration file for background location initialisation
  /// @return <success, content> where content is the error string if an error
  ///         occured, or the configuration JSON for initialisation
  Future<ServerReply> getInitConfig();

  /// Delete the account and its associated data on the server
  /// @return <success, content> where content is the error string if an error
  ///         occured
  Future<ServerReply> deleteAccount();

  /// Download the user data from server (account infos + habits)
  /// @return <success, content> where content is the error string if an error
  ///         occured, a raw json otherwise
  Future<ServerReply> downloadUserData();

}



/// Not used anymore:
// import 'package:tuple/tuple.dart';
// Tuple2<bool, String> ret = Tuple2(true, json.encode(RegisterData.empty()));