import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class LocationUtils {
  Location? location;

  static final LocationUtils _instance = LocationUtils._internal();

  factory LocationUtils() => _instance;

  LocationUtils._internal() {
    location ??= Location();
  }

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await location!.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location!.requestService();
      if (!serviceEnabled) {
        debugPrint('--0-0-0-0-0-0-serviceEnabled = false');
        return false;
      }
    }

    PermissionStatus permissionGranted = await location!.hasPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      permissionGranted = await location!.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        //未获取到权限
        debugPrint('--0-0-0-0-0-0-permissionGranted = false');
        return false;
      }
    }
    return true;
  }

  Future<LocationData> getLocationData() async {
    LocationData locationData = await location!.getLocation();
    return locationData;
  }
}
