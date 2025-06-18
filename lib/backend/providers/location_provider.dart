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
      print("📍 Starting location fetch...");
      isFetching = true;
      notifyListeners();

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("❌ Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("❌ Location permission permanently denied.");
        return;
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("❌ Location services are disabled.");
        return;
      }

      // Get position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      print("✅ Location fetched: lat = $latitude, long = $longitude");

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

          print("🏘️ Address fetched:");
          print("Street: $street");
          print("Area (Sub-locality): $area");
          print("City (Locality): $city");
          print("District (Sub-admin area): $district");
          print("State (Admin area): $state");
          print("Country: $country");
          print("Postal Code: $postalCode");
          print("Full Address: $fullAddress");
        } else {
          print("⚠️ No placemarks found.");
        }
      }
    } catch (e) {
      print("❗ Error fetching location: $e");
    } finally {
      isFetching = false;
      notifyListeners();
      print("📍 Location fetch completed.");
    }
  }
}
