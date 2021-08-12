import 'package:connectivity/connectivity.dart';


Future<bool> isNetworkOn() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return connectivityResult != ConnectivityResult.none;

}

Future<bool> isNetworkMobile() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return connectivityResult == ConnectivityResult.mobile;
}

Future<bool> isNetworkWifi() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return connectivityResult == ConnectivityResult.wifi;
}

Future<bool> isNetworkOf() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return connectivityResult == ConnectivityResult.none;
}