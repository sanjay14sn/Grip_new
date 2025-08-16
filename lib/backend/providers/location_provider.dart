import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  String? street;
  String? area;
  String? city;
  String? district;
  String? state;
  String? country;
  String? postalCode;
  String? fullAddress;
  bool isFetching = false;

  Future<void> fetchLocation() async {
    try {
      isFetching = true;
      notifyListeners();

      // Permissions check
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      // Wait 2 seconds to improve GPS fix
      await Future.delayed(const Duration(seconds: 2));

      // Fetch two positions and use the one with better accuracy
      final Position firstTry = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );
      await Future.delayed(const Duration(seconds: 2));
      final Position secondTry = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );

      final Position bestPosition =
          firstTry.accuracy < secondTry.accuracy ? firstTry : secondTry;

      latitude = bestPosition.latitude;
      longitude = bestPosition.longitude;

      // Reverse geocoding
      if (latitude != null && longitude != null) {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude!, longitude!);
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;

          street = placemark.street;
          area = placemark.subLocality;
          city = placemark.locality;
          district = placemark.subAdministrativeArea;
          state = placemark.administrativeArea;
          country = placemark.country;
          postalCode = placemark.postalCode;
          fullAddress =
              '${placemark.street}, ${placemark.subLocality}, ${placemark.subAdministrativeArea}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
        } else {}
      }
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }
}
