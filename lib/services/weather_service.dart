
import 'dart:async';
import 'package:weather/data/weather.dart';
import 'package:weather/db/info.dart';
import 'package:weather/repositories/info_repository.dart';
import 'package:weather/repositories/weather_api_repository.dart';

class WeatherService {

  final WeatherAPIRepository apiRepository;
  final InfoRepository infoRepository;

  WeatherService({ this.apiRepository, this.infoRepository });

  Future<Weather> getWeatherAPI({ double log, double lat, int cityId = 0 }) {
    Completer<Weather> completer = new Completer<Weather>();

    Future<Weather> api;
    if(cityId !=0 ){
      api = apiRepository.byCityID(cityId);
    } else {
      api = apiRepository.byCityCoord(lat, log);
    }

    api.then((weather) {
      setWeatherLocal(weather);
      completer.complete(weather);
    })
    .catchError((error){
      completer.completeError(error);
    });
      
    return completer.future;
  }

  Future<Weather> getWeatherLocal() {
    Completer<Weather> completer = new Completer<Weather>();

    Future<Info> db = infoRepository.selectOne("weather");
    db.then((value){
      if(value == null) {
        completer.complete(null);
      }
      Weather weather = convertInfoToWeather(value);
      completer.complete(weather);
    })
    .catchError((error){
      completer.completeError(error);
    });

    

    return completer.future;
  }

  Weather convertInfoToWeather(Info info) {
    return new Weather.fromInfo(info);
  }


  Future<void> setWeatherLocal(Weather weather) async {
    if(weather == null) {
      return;
    }
    Info info = await infoRepository.selectOne("weather");
    if(info == null) {
      await infoRepository.insert(weather.toInfo());
      return;
    }
    
    await infoRepository.update(weather.toInfo());
  }

}