import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnetion() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else {
    return false;
  }
}
