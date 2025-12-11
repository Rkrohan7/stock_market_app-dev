import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectionController;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  Stream<bool> get connectionStream {
    _connectionController ??= StreamController<bool>.broadcast();
    return _connectionController!.stream;
  }

  // Initialize connectivity monitoring
  Future<void> initialize() async {
    // Initial connectivity check
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final isConnected =
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);

    print("Connected: $isConnected");
  }

  // Check if connected
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isConnected = results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);
    return _isConnected;
  }

  // Get connection type
  Future<String> getConnectionType() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (results.contains(ConnectivityResult.none)) {
      return 'None';
    }
    return 'Unknown';
  }

  // Dispose
  void dispose() {
    _connectionController?.close();
  }
}
