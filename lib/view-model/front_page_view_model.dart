import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'dart:convert';

import 'package:winkclone/model/place.dart';

class FrontPageViewModel extends ChangeNotifier {
  List<Place> _places = [];
  bool _isGridLoading = false;
  bool _isPointsLoading = false;
  int _points = 0;
  double _redeemed = 0;

  List<Place> get places => _places;
  bool get isGridLoading => _isGridLoading;
  bool get isPointsLoading => _isPointsLoading;

  set points(int p){
    _points = p;
    notifyListeners();
  }

  set redeemed(double r){
    _redeemed = r;
    notifyListeners();
  }

  int get points => _points;
  double get redeemed => _redeemed;

  Future<void> fetchPlaces() async {
    _isGridLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${constants.backend}/api/places'),
        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);
        _places = jsonList.map((json) => Place.fromJson(json)).toList();

        _isGridLoading = false;
        notifyListeners();
      } else {
        _isGridLoading = true;
        notifyListeners();
      }
    } catch (e) {
      _isGridLoading = true;
      notifyListeners();

      print('Error: $e');
    }
  }

  Future<void> fetchUserPoints(userId) async {
    String uri = "${constants.backend}/api/users/$userId";

    print("res106uri");
    print(uri);

    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer ${constants.session['token']}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var user = jsonDecode(response.body);
      _points = user['points'];
      _redeemed = user['rePoints'];

      _isPointsLoading = false;
      notifyListeners();
    } else {
      _isPointsLoading = true;
      notifyListeners();
      print("res106 : " + response.statusCode.toString());
    }
  }
}
