
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weather/data/option.dart';
import 'package:weather/db/info.dart';
import 'package:weather/repositories/info_repository.dart';

class AppService {

  final InfoRepository infoRepository;

  Option _option;

  AppService({
    this.infoRepository
  });

  Option get option => _option;

  Future<void> getOption()  async {
    Info info = await this.infoRepository.selectOne("option");
    if(info != null) {
      _option = Option.fromInfo(info);
    } else {
      _option = new Option();
      _option.type = 1;
    }
   
  }

  Future<void> setOption(Option option)  async {
    Info _info = await this.infoRepository.selectOne("option");
    if(_info == null) {
      await this.infoRepository.insert(option.toInfo());
    } else {
      await this.infoRepository.update(option.toInfo());
    }
   
  }


  Future<LocationData> getCoord() async {
    LocationData currentLocation;

    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      _option.lat = currentLocation.latitude;
      _option.log = currentLocation.longitude;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        //error = 'Permission denied';
      } 
      
    }
    return currentLocation;
  }

}