import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<void> updateLocationOnce(String userId) async {
    final hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return;

    final locationData = await _location.getLocation();

    await _firestore.collection('users').doc(userId).set({
      'location': {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      }
    }, SetOptions(merge: true));
  }
}
