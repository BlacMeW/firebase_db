import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_db/services/location_service.dart';

class GpsUpdateScreen extends StatefulWidget {
  const GpsUpdateScreen({super.key});

  @override
  State<GpsUpdateScreen> createState() => _GpsUpdateScreenState();
}

class _GpsUpdateScreenState extends State<GpsUpdateScreen> {
  final locationService = LocationService();
  final String userId = "user_001"; // တကယ်လိုအပ်ရင် FirebaseAuth ထဲက ယူ

  bool _loading = false;
  String? _status;

  Future<void> _updateLocation() async {
    setState(() {
      _loading = true;
      _status = null;
    });

    try {
      await locationService.updateLocationOnce(userId);
      setState(() {
        _status = "📍 Location updated to Firestore!";
      });
    } catch (e) {
      setState(() {
        _status = "❌ Failed: $e";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manual Location Update")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Update My Location"),
              onPressed: _updateLocation,
            ),
            const SizedBox(height: 20),
            if (_status != null)
              Text(
                _status!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
