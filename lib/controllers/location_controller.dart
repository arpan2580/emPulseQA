// import 'dart:developer';
import 'package:location/location.dart';

Future<LocationData> getUserLocation() async {
  Location _location = Location();
  bool _isServiceEnabled;
  PermissionStatus _permissionStatus;
  LocationData? locale;

  _isServiceEnabled = await _location.serviceEnabled();

  if (!_isServiceEnabled) {
    _isServiceEnabled = await _location.requestService();
    if (!_isServiceEnabled) {
      // Do SomeThing
    }
  }

  // Executing below code when location service is Enabled
  _permissionStatus = await _location.hasPermission();

  if (_permissionStatus == PermissionStatus.denied) {
    _permissionStatus = await _location.requestPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      return Future.error("Permission Denied Forever");
    }
  }

  // Executing below code when location permission is Granted
  locale = await _location.getLocation();

  return locale;
}
