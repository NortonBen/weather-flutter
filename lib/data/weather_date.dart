
import 'package:weather/data/weather.dart';

import '../util.dart';

class WeatherDate {

  int dt;
  String dt_txt;
  String icon;
  double temp;

  WeatherDate({
    this.dt,
    this.icon,
    this.temp,
    this.dt_txt,
  });

  String getDate() {
    DateTime date = DateTime.parse(dt_txt);
    return  Util.twoNumber(date.day)+"/"+ Util.twoNumber(date.month);
  }

  factory WeatherDate.fromInfoWeather(InfoWeather info) {
    return new WeatherDate(
      dt: info.dt,
      dt_txt: info.dt_text,
      icon: info.weather.icon,
      temp: info.main.temp,
    );
  }
}