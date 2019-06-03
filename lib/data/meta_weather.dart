


import 'package:weather/data/weather.dart';
import 'package:weather/data/weatherHour.dart';
import 'package:weather/data/weather_date.dart';
import 'package:weather/data/weather_info_detail.dart';

class MetaWeather {

  City city;
  String cod;
  double message;
  int cnt;

  List<WeatherDate> listDate;
  Weather weather;

  Map<String, List<WeatherInfoDetail>> listMeta;

  MetaWeather(Weather weather) {
    this.weather = weather;
    this.city = weather.city;
    this.cod = weather.cod;
    this.cnt = weather.cnt;
    this.message = weather.message;

    this.listDate = new List<WeatherDate>();
    this.listMeta = new Map<String, List<WeatherInfoDetail>>();
    this.convertData();
  }

  convertData() {
    for( var item in this.weather.list) {
      if(this.listMeta.containsKey(item.getDate())) {
        List<WeatherInfoDetail> list = this.listMeta[item.getDate()];
        WeatherInfoDetail value = WeatherInfoDetail.fromInfoWeather(item);
        value.city = this.weather.city.name;
        list.add(value);
      } else {
        List<WeatherInfoDetail> list = new List<WeatherInfoDetail>();
        WeatherInfoDetail value = WeatherInfoDetail.fromInfoWeather(item);
        WeatherDate wDate = WeatherDate.fromInfoWeather(item);
        value.city = this.weather.city.name;
        list.add(value);
        this.listDate.add(wDate);
        this.listMeta[item.getDate()] = list;
      }
    }
  }

  WeatherInfoDetail getDetail(String date, int dt) {
    if(!this.listMeta.containsKey(date)) {
      return new WeatherInfoDetail();
    }
    List<WeatherInfoDetail> list = this.listMeta[date];
    if(dt == 0) {
      return list.first;
    }
    for(var item in list) {
      if(item.dt == dt) {
        return item;
      }
    }
    return list.last;
  }

  WeatherInfoDetail getDetailNow(String date) {
    if(!this.listMeta.containsKey(date)) {
      return new WeatherInfoDetail();
    }

    List<WeatherInfoDetail> list = this.listMeta[date];
    int dt = DateTime.now().microsecondsSinceEpoch;
    for(var item in list) {
      if(item.dt > dt) {
        return item;
      }
    }
    return list.last;
  }

  List<WeatherHour> getHour(String date) {
    if(!this.listMeta.containsKey(date)) {
      return new List<WeatherHour>();
    }
    List<WeatherInfoDetail> list = this.listMeta[date];
    List<WeatherHour> listHour = new List<WeatherHour>();

    for(var item in list) {
      WeatherHour hour = new WeatherHour(
        dt: item.dt,
        dt_txt: item.dt_txt,
        icon: item.icon,
        temp: item.temp
      );
      listHour.add(hour);
    }
    return listHour;
  }
}