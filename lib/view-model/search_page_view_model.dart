import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';

class SearchPageViewModel extends ChangeNotifier {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<dynamic> _places = [];
  bool _isLoading = false;

  TextEditingController get controller => _controller;
  List<dynamic> get places => _places;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start new debounce
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        _fetchPlaces(query);
      } else {
        _places.clear();
        notifyListeners();
      }
    });
  }

  Future<void> _fetchPlaces(String query) async {
    final response = await http.get(
      Uri.parse(
        "${constants.backend}/api/places/search?query=$query&page=0&size=5",
      ),
      headers: {
        'Authorization': 'Bearer ${constants.session['token']}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _places = data['content'];
      notifyListeners();
    } else {
      throw Exception("Failed to load places");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
