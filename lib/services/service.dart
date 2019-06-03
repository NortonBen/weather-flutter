
import 'package:weather/repositories/repositories.dart';
import 'package:weather/services/app_service.dart';
import 'package:weather/services/weather_place_service.dart';
import 'package:weather/services/weather_service.dart';
import 'package:google_maps_webservice/places.dart';

class Service {
  final Repositories repositories;
  
  static AppService _appService;
  static WeatherService _weatherService;
  static GoogleMapsPlaces _places;
  static WeatherPlaceService _weatherPlace;

  String kGoogleApiKey = "AIzaSyBXZxfZmcj9W-IpGohjKDQwhYuSMUKWFjU";

  Service(this.repositories);

  AppService get appService {
    if(_appService == null) {
      _appService = new AppService(
        infoRepository: repositories.infoRepository,
      );
    }
    return Service._appService;
  }

  WeatherPlaceService get weatherPlaceService {
    if(_weatherPlace == null) {
      _weatherPlace = new WeatherPlaceService(
        infoRepository: repositories.infoRepository,
      );
    }
    return Service._weatherPlace;
  }

  GoogleMapsPlaces get googleMapsPlaces {
    if(_places == null) {
      _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    }
    return Service._places;
  }

  WeatherService get weatherService {
    if(_weatherService == null) {
      _weatherService = new WeatherService(
        apiRepository: repositories.weatherAPIRepository,
        infoRepository: repositories.infoRepository,
      );
    }
    return Service._weatherService;
  }

}