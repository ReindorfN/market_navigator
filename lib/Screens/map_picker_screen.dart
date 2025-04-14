import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null) {
                Navigator.pop(context, _selectedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a location')),
                );
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        onTap: (LatLng location) {
          setState(() {
            _selectedLocation = location;
          });
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(-34.6037, -58.3816), // Default to Buenos Aires
          zoom: 10,
        ),
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: const MarkerId('selectedLocation'),
                  position: _selectedLocation!,
                ),
              }
            : {},
      ),
    );
  }
}
