import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';
import 'dart:convert';

import 'package:winkclone/model/place.dart';

class CatalogPageViewModel extends ChangeNotifier {
  List<Place> _places = [];
  bool _isLoading = false;

  List<Place> get places => _places;
  bool get isLoading => _isLoading;

  Future<void> fetchPlaces() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        // Uri.parse('http://10.0.2.2:8080/api/places'),
        Uri.parse('${constants.backend}/api/places'),
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
}
