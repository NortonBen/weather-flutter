import 'package:http/http.dart' as http;
import 'package:weather/data/weather.dart';
import 'dart:convert';

class WeatherAPIRepository {

  final String url = "http://api.openweathermap.org/data/2.5/forecast";
  final String appId = "763d485d0eaef1d20e1f7e355b8bb35a";

  Future<Weather> byCityID(int id) async{
    final response = await http.get('$url?id=$id&appid=$appId');
    if(response.statusCode != 200) {
      return null;
    }
    Map valueMap  = json.decode(response.body);
    return new Weather.fromMap(valueMap);
  }

  Future<Weather> byCityCoord(double lat, double lon) async{
    String link = '$url?lat=$lat&lon=$lon&appid=$appId';
    final response = await http.get(link);
    if(response.statusCode != 200) {
      return null;
    }
    Map valueMap  = json.decode(response.body);
    return new Weather.fromMap(valueMap);
  }
}