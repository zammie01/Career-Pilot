import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  NetworkInfo._privateConstructor();
  static final NetworkInfo instance = NetworkInfo._privateConstructor();

  /// Returns true if device has internet connection
  Future<bool> get isConnected async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
