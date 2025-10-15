import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';
import 'package:winkclone/model/place.dart';
import 'package:winkclone/view/location_detail_page.dart';

class EarnPointViewModel extends ChangeNotifier {
  //map tab index, for buttons coloring
  int selectedIndex = 0;
  GoogleMapController? _controller;
  Position? _currentPosition;
  BitmapDescriptor? _currentLocationIcon;
  Set<Marker> _markers = {};

  int get getSelectedIndex => selectedIndex;
  GoogleMapController? get controller => _controller;
  Position? get currentPosition => _currentPosition;
  BitmapDescriptor? get currentLocationIcon => _currentLocationIcon;
  Set<Marker>? get markers => _markers;

  final Completer<GoogleMapController> _mapController = Completer();

  List<Place> _places = [];
  List<Place> get places => _places;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Completer<GoogleMapController> get mapController => _mapController;

  LatLng get initialPosition {
    if (_currentPosition != null) {
      return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }
    return const LatLng(1.3521, 103.8198); // default Singapore
  }

  double get initialZoom => _currentPosition != null ? 14 : 10.5;

  void onMapCreated(GoogleMapController controller) {
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
    _controller = controller;
  }

  Future<void> fetchCoordinates() async {
    try {
      final response = await http.get(
        // Uri.parse('http://10.0.2.2:8080/api/places'),
        Uri.parse('${constants.backend}/api/places/coordinates'),
        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);

        _places = jsonList.map((json) => Place.fromJson(json)).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = true;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = true;
      notifyListeners();

      print('Error: $e');
    }
  }

  Future<void> initialize(BuildContext context) async {
    await _setCustomMarkerIcon();
    await fetchCoordinates();
    _loadMarkers(context);
    await _determinePosition();
  }

  Future<void> _setCustomMarkerIcon() async {
    _currentLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'images/location.png',
    );
  }

  Future<void> _determinePosition() async {
    print('Checking permission...');
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = position;
    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        icon:
            _currentLocationIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    );
    notifyListeners();

    _controller?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  void _loadMarkers(BuildContext context) {
    Set<Marker> newMarkers = {};
    for (var p in _places) {
      int id = p.id;
      double latitude = p.latitude ?? 0;
      double longitude = p.longitude ?? 0;
      String name = p.name;
      String type = p.type;

      newMarkers.add(
        Marker(
          markerId: MarkerId(id.toString()),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: "$name - $type \n Tap to view",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LocationDetailPage(index: id),
                ),
              );
            },
          ),
        ),
      );
    }
    _markers.addAll(newMarkers);
    notifyListeners();
  }

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateController(GoogleMapController newController) {
    _controller = newController;
  }

  void jumpToCurrentLocation() async {
    selectedIndex = 0;
    notifyListeners();
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentPosition!.latitude, currentPosition!.longitude),
        14,
      ),
    );
  }

  void jumpToAllLocations() async {
    selectedIndex = 1;
    notifyListeners();
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(1.3521, 103.8198), // Singapore
        10.5,
      ),
    );
  }

  void initPosition() {}
}
