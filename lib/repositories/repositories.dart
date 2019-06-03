

import 'package:weather/db/datacontext.dart';
import 'package:weather/repositories/info_repository.dart';
import 'package:weather/repositories/weather_api_repository.dart';

class Repositories {
  final DataContext dbContext;
  static InfoRepository _info;
  static WeatherAPIRepository _weather;

  Repositories(this.dbContext);


  InfoRepository get infoRepository {
    if(_info == null) {
      _info = new InfoRepository(database: dbContext.database);
    }
    
    return _info;
  }

  WeatherAPIRepository get weatherAPIRepository {
    if(_weather == null) {
      _weather = new WeatherAPIRepository();
    }
    
    return _weather;
  }
}