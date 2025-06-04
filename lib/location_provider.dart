import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
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

  final loc.Location _location = loc.Location();

  Future<void> fetchLocation() async {
    try {
      print("📍 Starting location fetch...");
      isFetching = true;
      notifyListeners();

      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        print("⚠️ Location service not enabled. Requesting...");
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          print("❌ Location service not enabled. Aborting.");
          return;
        }
      }

      loc.PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        print("🔐 Permission denied. Requesting...");
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          print("❌ Permission not granted. Aborting.");
          return;
        }
      }

      final loc.LocationData locationData = await _location.getLocation();
      latitude = locationData.latitude;
      longitude = locationData.longitude;

      print("✅ Location fetched: lat = $latitude, long = $longitude");

      if (latitude != null && longitude != null) {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude!, longitude!);
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;

          street = placemark.street;
          area = placemark.subLocality;
          city = placemark.locality;
          district = placemark.subAdministrativeArea; // <- District
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
          print("⚠️ No placemarks found for coordinates.");
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
