import '../util.dart';

class WeatherHour {

  int dt;
  String dt_txt;
  String icon;
  double temp;

  WeatherHour({
    this.dt,
    this.icon,
    this.temp,
    this.dt_txt,
  });

  String getTime() {
    DateTime date = DateTime.parse(dt_txt);
    return Util.twoNumber(date.hour) +":"+  Util.twoNumber(date.minute);
  }
}