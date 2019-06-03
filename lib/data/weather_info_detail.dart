
import '../util.dart';
import 'weather.dart';

class WeatherInfoDetail {

  double temp;
  double temp_min;
  double temp_max;
  int humidity;
  double wind;
  int cloud;
  int dt;
  String dt_txt;
  String icon;
  String main;
  String description;

  String city;

  WeatherInfoDetail({
    this.temp,
    this.temp_min,
    this.temp_max,
    this.humidity,
    this.wind,
    this.cloud,
    this.dt,
    this.dt_txt,
    this.icon,
    this.description,
    this.main
  });

  DateTime getTime() {
    return DateTime.parse(this.dt_txt);
  }

  String getDate() {
    DateTime date = this.getTime();
    return   Util.twoNumber(date.day)+"/"+  Util.twoNumber(date.month);
  }

  String getHour() {
    DateTime date = this.getTime();
    return Util.twoNumber(date.hour) +":"+  Util.twoNumber(date.minute);
  }

  String getTimeShow() {
    DateTime now = new DateTime.now();
    DateTime time = this.getTime();
    if(now.year == time.year && now.month == time.month && now.day == time.day) {
      return "Hôm nay";
    }
    return getDate();
  }

  factory WeatherInfoDetail.fromInfoWeather(InfoWeather data){

    return new WeatherInfoDetail(
      description: data.weather.description,
      icon: data.weather.icon,
      main: data.weather.main,
      dt: data.dt,
      dt_txt: data.dt_text,
      humidity: data.main.humidity,
      temp: data.main.temp,
      temp_max: data.main.temp_max,
      temp_min: data.main.temp_min,
      wind: data.wind.speed,
      cloud: data.clouds.all,
    );
  } 
}