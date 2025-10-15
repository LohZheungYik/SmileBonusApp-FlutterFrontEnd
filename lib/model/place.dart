import 'dart:math';

import 'package:winkclone/constants.dart';

class Place {
  int id;
  String name;
  String type;
  List? photoUrls;
  String? address;
  String? website;
  String? googleMapsUrl;
  double? latitude;
  double? longitude;
  double? rating;

  bool? havePoint;
  int? pointType;

  Place({
    required this.id,
    required this.name,
    required this.photoUrls,
    required this.type,

    this.address,
    this.website,
    this.googleMapsUrl,
    this.latitude,
    this.longitude,
    this.rating,
  }) {
    if (!constants.bonus.containsKey(id)) {
      havePoint = Random().nextBool();
      pointType = Random().nextInt(4);
      constants.bonus[id] = [havePoint, pointType];
    }
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      name: json['name'],
      type: json['type'],
      photoUrls: json['photoUrls'],

      address: json['address'],
      website: json['website'],
      googleMapsUrl: json['googleMapsUrl'],
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }
}
