

import 'dart:convert';

import 'package:weather/db/info.dart';

class Option {
  int type;
  int cityId;
  double lat;
  double log;

  Option({ this.type, this.cityId, this.lat, this.log });

  factory Option.fromMap(Map<String, dynamic> data) => new Option(
    type: data["type"],
    cityId: data["city_id"],
    log: data["log"],
    lat: data["lat"],
  );

  factory Option.fromInfo(Info info) {
    Map<String, dynamic> map = jsonDecode(info.value);
    return Option.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'city_id': cityId,
      'lat': lat,
      'log': log,
    };
  }

  Info toInfo() {
    String json = jsonEncode(toMap());
    return new Info(
      key: 'option',
      value: json,
    );
  }
}