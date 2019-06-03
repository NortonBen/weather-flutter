


import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/db/info.dart';

class PlaceInfo {

  List<LatLng> places;

  PlaceInfo({ this.places });

  factory PlaceInfo.fromMap(Map<String, dynamic> data){
    List<dynamic> placesMeta = data["places"];
    List<LatLng> places = new List();
    for(dynamic item in placesMeta) {
      places.add(
        LatLng(
          item['latitude'].toDouble(),
          item['longitude'].toDouble(),
        )
      );
    }

    return new PlaceInfo(
        places: places,
    );
  }

  factory PlaceInfo.fromInfo(Info info) {
    Map<String, dynamic> map = jsonDecode(info.value);
    return PlaceInfo.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'places': places.map<Map<String, dynamic>>((data){
        return latLngToJSON(data);
      }).toList(),
    };
  }

  Map<String, dynamic> latLngToJSON(LatLng pos) {
    return { 
      'latitude': pos.latitude,
      'longitude': pos.longitude
    };
  }

  Info toInfo() {
    String json = jsonEncode(toMap());
    return new Info(
      key: 'place_info',
      value: json,
    );
  }
}