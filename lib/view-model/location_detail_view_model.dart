import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winkclone/model/place.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';
import 'dart:convert';

import 'package:winkclone/view-model/front_page_view_model.dart';

class LocationDetailViewModel extends ChangeNotifier {
  Place? _place;
  bool _isLoading = false;

  Place? get place => _place;
  bool get isLoading => _isLoading;

  Future<void> fetchPlaceDetails(int index) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${constants.backend}/api/places/$index'),
        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonItem = json.decode(response.body);
        _place = Place.fromJson(jsonItem);

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

  Future<void> launchMap(double? latitude, double? longitude) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  Future<void> launchExternalWebsite(String website) async {
    final Uri uri = Uri.parse(website);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $website';
    }
  }

  Future<void> grabPoints(int index, FrontPageViewModel pointVm, BuildContext context) async {
    int availablePoints =
        constants.pointType[constants.bonus[index]![1]];

    final response = await http.patch(
      Uri.parse(
        "${constants.backend}/api/users/earnPoints/${constants.session['id']}?newPoints=$availablePoints",
      ),
      headers: {
        'Authorization': 'Bearer ${constants.session['token']}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      constants.bonus[index]![0] = false;
      notifyListeners();

      final data = jsonDecode(response.body);

      int updatedPoints = data['points'];

      pointVm.points = updatedPoints;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You earned $availablePoints points!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please try again later"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
