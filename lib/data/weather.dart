
import 'dart:convert';

import 'package:weather/db/info.dart';

class Coord {

  double lat;
  double lon;

  Coord({ this.lat, this.lon });
  
  factory Coord.fromMap(Map<String, dynamic> data) => new Coord(
    lat: data["lat"],
    lon: data["lon"],
  );
}

class City {
  int id;
  String name;
  Coord coord;
  String country;

  City({ this.id, this.name, this.coord, this.country });


  factory City.fromMap(Map<String, dynamic> data) => new City(
    id: data["id"],
    name: data["name"],
    country: data["country"],
    coord: new Coord.fromMap(data["coord"]),
  );

}

class Clouds {
  int all;

  Clouds({ this.all });

  factory Clouds.fromMap(Map<String, dynamic> data) => new Clouds(
    all: data["all"],
  );
}

class Wind {
  double speed;
  double deg;

  Wind({
    this.deg,
    this.speed
  });

  factory Wind.fromMap(Map<String, dynamic> data) => new Wind(
    speed: data["speed"].toDouble(),
    deg: data["deg"].toDouble(),
  );
}

class Snow {
  double h;

  Snow({
    this.h
  });

  factory Snow.fromMap(Map<String, dynamic>  weather) {
    if(!weather.containsKey("snow")) {
      return new Snow(
        h: 0,
      );
    }
    Map<String, dynamic> data = weather['snow'];
    if(!data.containsKey("3h")) {
      return new Snow(
        h: 0,
      );
    }
    return new Snow(
      h: data["3h"],
    );
  }
} 

class Rain {
  double h;

  Rain({
    this.h
  });

  factory Rain.fromMap(Map<String, dynamic> weather) {
    if(!weather.containsKey("rain")) {
      return new Rain(
        h: 0,
      );
    }
    Map<String, dynamic> data = weather['rain'];
    if(!data.containsKey("3h")) {
      return new Rain(
        h: 0,
      );
    }
    return new Rain(
      h: data["3h"].toDouble(),
    );
  }
} 


class Sys {
  String pod;

  Sys({
    this.pod
  });

  factory Sys.fromMap(Map<String, dynamic> data) => new Sys(
    pod: data["pod"],
  );
}

class MainInfo {
  double temp;
  double temp_min;
  double temp_max;
  double pressure;
  double sea_level;
  double grnd_level;
  int humidity;
  double temp_kf;

  MainInfo({
    this.grnd_level,
    this.humidity,
    this.pressure,
    this.sea_level,
    this.temp_kf,
    this.temp,
    this.temp_max,
    this.temp_min,
  });

  factory MainInfo.fromMap(Map<String, dynamic> data) => new MainInfo(
    grnd_level: data["grnd_level"].toDouble(),
    pressure: data["pressure"].toDouble(),
    humidity: data["humidity"],
    sea_level: data["sea_level"].toDouble(),
    temp_kf: data["temp_kf"].toDouble(),
    temp: data["temp"].toDouble(),
    temp_min: data["temp_min"].toDouble(),
    temp_max: data["temp_max"].toDouble(),   
  );
}

class WeatherData {
  int id;
  String main;
  String description;
  String icon;

  WeatherData({
    this.description,
    this.icon,
    this.id,
    this.main
  });

  factory WeatherData.fromMap(Map<String, dynamic> data) => new WeatherData(
    id: data["id"],
    description: data["description"],
    icon: data["icon"],
    main: data["main"],
  );

}

class InfoWeather {

  int dt;
  MainInfo main;
  WeatherData weather;
  Wind wind;
  Sys sys;
  Clouds clouds;
  Snow snow;
  Rain rain;
  String dt_text;

  InfoWeather({
    this.dt,
    this.dt_text,
    this.weather,
    this.main,
    this.clouds,
    this.snow,
    this.rain,
    this.sys,
    this.wind
  });

  String getDate() {
    DateTime date = this.time;
    return  twoNumber(date.day)+"/"+ twoNumber(date.month);
  }

  String twoNumber(int number) {
    String str = number.toString();
    if(str.length > 1) {
      return str;
    }
    return "0"+str;
  }

  DateTime get time => DateTime.parse(this.dt_text);

  factory InfoWeather.fromMap(Map<String, dynamic> data) => new InfoWeather(
    dt: data["dt"],
    dt_text: data["dt_txt"],
    weather: new WeatherData.fromMap(data["weather"][0]),
    main: new MainInfo.fromMap(data["main"]),
    clouds: new Clouds.fromMap(data["clouds"]),
    snow: new Snow.fromMap(data),
    rain: new Rain.fromMap(data),
    sys: new Sys.fromMap(data["sys"]),
    wind: new Wind.fromMap(data["wind"]),
  );

}


class Weather {
  City city;
  String cod;
  double message;
  int cnt;
  List<InfoWeather> list;
  String json;

  Weather({ this.city, this.cod, this.message, this.cnt, this.list, this.json });

  factory Weather.fromMap(Map<String, dynamic> data) {

    List<InfoWeather> listInfo = List.generate(data["list"].length, (i) {
      return new InfoWeather.fromMap(data["list"][i]);
    });
    
    return new Weather(
      cod: data["cod"],
      message: data["message"],
      cnt: data["cnt"],
      city: new City.fromMap(data["city"]),
      list: listInfo,
      json: jsonEncode(data)
    );
  }

  
  factory Weather.fromInfo(Info info) {
    Map<String, dynamic> map = jsonDecode(info.value);
    return Weather.fromMap(map);
  }

  Info toInfo() {
    return new Info(
      key: 'weather',
      value: json,
    );
  }
}