import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:indiclassifieds/services/SecureStorageService.dart';
import 'package:permission_handler/permission_handler.dart' as OpenAppSettings;

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For network checks
import 'package:location/location.dart' as loc;
import 'location_state.dart';

// --- Storage keys ---
const _kLocNameKey = 'LocName';
const _kLatLngKey = 'latlngs';

class LocationCubit extends Cubit<LocationState> {
  final loc.Location _location = loc.Location();
  final SecureStorageService _storage = SecureStorageService.instance;

  LocationCubit() : super(LocationInitial());

  /// Check and handle permission + location
  Future<void> checkLocationPermission() async {
    emit(LocationLoading());
    try {
      if (!await _ensureServiceEnabled()) {
        emit(LocationServiceDisabled());
        return;
      }

      final permission = await _location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        emit(LocationPermissionDenied());
      } else if (permission == loc.PermissionStatus.deniedForever) {
        await _emitSavedOrError(
          "Location permissions are permanently denied. Please enable them in Settings.",
        );
      } else {
        await getLatLong();
      }
    } catch (e, stack) {
      debugPrint('checkLocationPermission error: $e\n$stack');
      await _emitSavedOrError("Failed to check location permissions.");
    }
  }

  /// Request permission & handle result
  Future<void> requestLocationPermission() async {
    emit(LocationLoading());
    try {
      if (!await _ensureServiceEnabled()) {
        emit(LocationServiceDisabled());
        return;
      }
      var permission = await _location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission == loc.PermissionStatus.denied) {
          await _emitSavedOrDenied();
          return;
        } else if (permission == loc.PermissionStatus.deniedForever) {
          await _emitSavedOrError(
            "Location permissions are permanently denied. Please enable them in Settings.",
          );
          return;
        }
      } else if (permission == loc.PermissionStatus.deniedForever) {
        await _emitSavedOrError(
          "Location permissions are permanently denied. Please enable them in Settings.",
        );
        return;
      }

      await getLatLong();
    } catch (e, stack) {
      debugPrint('requestLocationPermission error: $e\n$stack');
      await _emitSavedOrError("Failed to request location.");
    }
  }

  /// Fetch current lat/lng & reverse geocode
  Future<void> getLatLong() async {
    emit(LocationLoading());
    try {
      final permission = await _location.hasPermission();
      if (permission == loc.PermissionStatus.denied ||
          permission == loc.PermissionStatus.deniedForever) {
        await _emitSavedOrError("Location permission not granted.");
        return;
      }
      if (!await _location.serviceEnabled()) {
        emit(LocationServiceDisabled());
        return;
      }
      final locationData = await _getLocationWithRetry();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;

      if (latitude == null || longitude == null) {
        throw Exception('Invalid coordinates received');
      }

      final latlng = "$latitude,$longitude";
      final isConnected =
          (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
      final locationName = await _geocode(latitude, longitude, isConnected);

      // Save to secure storage
      await _storage.setString(_kLocNameKey, locationName);
      await _storage.setString(_kLatLngKey, latlng);

      emit(LocationLoaded(locationName: locationName, latlng: latlng));
    } catch (e, stack) {
      debugPrint('getLatLong error: $e\n$stack');
      await _emitSavedOrDefault();
    }
  }

  /// Retry logic + timeout for fetching location
  Future<loc.LocationData> _getLocationWithRetry({int retries = 2}) async {
    for (int i = 0; i <= retries; i++) {
      try {
        return await _location.getLocation().timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException("Timeout getting location"),
        );
      } catch (e) {
        if (i == retries) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw Exception("Location fetch failed");
  }

  /// Retry geocoding with fallback
  Future<String> _geocode(double lat, double lon, bool isConnected) async {
    for (int attempt = 0; attempt <= 2; attempt++) {
      try {
        if (!isConnected) {
          return (await _getCachedAddress('$lat,$lon')) ?? 'Current location';
        }

        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // iOS-friendly delay

        final placemarks = await placemarkFromCoordinates(
          lat,
          lon,
        ).timeout(const Duration(seconds: 10));

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final address = [
            p.street,
            p.subLocality,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          return address.isEmpty ? 'Current location' : address;
        }
      } catch (e) {
        if (attempt == 2) {
          return (await _getCachedAddress('$lat,$lon')) ?? 'Current location';
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    return 'Current location';
  }

  /// Return cached address if matched
  Future<String?> _getCachedAddress(String latlng) async {
    final savedLatLng = await _storage.getString(_kLatLngKey);
    final savedName = await _storage.getString(_kLocNameKey);
    if (savedLatLng == latlng &&
        savedName != null &&
        savedName != 'Current location') {
      return savedName;
    }
    return null;
  }

  /// Check and prompt for service
  Future<bool> _ensureServiceEnabled() async {
    bool enabled = await _location.serviceEnabled();
    if (!enabled) {
      enabled = await _location.requestService();
    }
    return enabled;
  }

  Future<void> _emitSavedOrError(String message) async {
    final name = await _storage.getString(_kLocNameKey);
    final coords = await _storage.getString(_kLatLngKey);
    if (name != null && coords != null && name != 'Current location') {
      emit(LocationLoaded(locationName: name, latlng: coords));
    } else {
      emit(LocationError(message));
    }
  }

  Future<void> _emitSavedOrDefault() async {
    final name = await _storage.getString(_kLocNameKey);
    final coords = await _storage.getString(_kLatLngKey);
    if (name != null && coords != null && name != 'Current location') {
      emit(LocationLoaded(locationName: name, latlng: coords));
    } else {
      emit(
        LocationLoaded(
          locationName: 'Gachibowli, Hyderabad',
          latlng: '17.4401,78.3489',
        ),
      );
    }
  }

  Future<void> _emitSavedOrDenied() async {
    final name = await _storage.getString(_kLocNameKey);
    final coords = await _storage.getString(_kLatLngKey);
    if (name != null && coords != null && name != 'Current location') {
      emit(LocationLoaded(locationName: name, latlng: coords));
    } else {
      emit(LocationPermissionDenied());
    }
  }

  Future<void> useSavedLocation(String locationName, String latlng) async {
    emit(LocationLoaded(locationName: locationName, latlng: latlng));
  }

  Future<void> handlePermissionDismissed() async {
    final name = await _storage.getString(_kLocNameKey);
    final coords = await _storage.getString(_kLatLngKey);
    if (name != null && coords != null && name != 'Current location') {
      emit(LocationLoaded(locationName: name, latlng: coords));
    } else {
      emit(
        LocationLoaded(
          locationName: 'Gachibowli, Hyderabad',
          latlng: '17.4401,78.3489',
        ),
      );
    }
  }
}
