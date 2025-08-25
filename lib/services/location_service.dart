import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/cambodia_address_formatter.dart';

/// Service for handling location capture and address formatting
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Get current location with proper permission handling
  Future<LocationData?> getCurrentLocation({
    required BuildContext context,
    bool showLoadingDialog = true,
  }) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog(context);
        return null;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDialog(context, 'Location permission is required to record your current location.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog(context, 'Location permissions are permanently denied. Please enable them in settings.');
        return null;
      }

      // Show loading dialog if requested
      if (showLoadingDialog) {
        _showLoadingDialog(context);
      }

      try {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );

        // Get address from coordinates
        String formattedAddress = await _getFormattedAddress(
          position.latitude,
          position.longitude,
        );

        // Hide loading dialog
        if (showLoadingDialog && context.mounted) {
          Navigator.of(context).pop();
        }

        return LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          address: formattedAddress,
          accuracy: position.accuracy,
          timestamp: DateTime.now(),
        );
      } catch (e) {
        // Hide loading dialog
        if (showLoadingDialog && context.mounted) {
          Navigator.of(context).pop();
        }
        
        if (e is LocationServiceDisabledException) {
          _showLocationServiceDialog(context);
        } else {
          _showErrorDialog(context, 'Failed to get location: ${e.toString()}');
        }
        return null;
      }
    } catch (e) {
      _showErrorDialog(context, 'Location error: ${e.toString()}');
      return null;
    }
  }

  /// Format address from coordinates using geocoding
  Future<String> _getFormattedAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return CambodiaAddressFormatter.formatCambodianAddress(place);
      } else {
        return _formatCoordinatesAddress(latitude, longitude);
      }
    } catch (e) {
      // Fallback to coordinates if geocoding fails
      return _formatCoordinatesAddress(latitude, longitude);
    }
  }

  /// Format coordinates as address fallback
  String _formatCoordinatesAddress(double latitude, double longitude) {
    return 'Current Location\nLat: ${latitude.toStringAsFixed(6)}\nLng: ${longitude.toStringAsFixed(6)}\nPhnom Penh, Cambodia';
  }

  /// Show loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Getting your location...'),
          ],
        ),
      ),
    );
  }

  /// Show location service disabled dialog
  void _showLocationServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
          'Please enable location services in your device settings to record your current location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openLocationSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  /// Show permission required dialog
  void _showPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Get distance between two coordinates in meters
  double getDistanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }
}

/// Data class for location information
class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final double? accuracy;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.accuracy,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'LocationData(lat: $latitude, lng: $longitude, address: $address)';
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create from map
  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      accuracy: map['accuracy']?.toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
