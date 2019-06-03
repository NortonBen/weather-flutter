




import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/data/place_info.dart';
import 'package:weather/db/info.dart';
import 'package:weather/repositories/info_repository.dart';

class WeatherPlaceService {

  final InfoRepository infoRepository;
  PlaceInfo placeInfo;

  WeatherPlaceService({ this.infoRepository });

  Future<PlaceInfo> getPlaceLocal() {
    Completer<PlaceInfo> completer = new Completer<PlaceInfo>();

    Future<Info> db = infoRepository.selectOne("place_info");
    db.then((value){
      if(value == null) {
        this.placeInfo = new PlaceInfo();
        this.placeInfo.places = List();
        completer.complete(this.placeInfo);
        return;
      }
      PlaceInfo place = convertInfoToPlace(value);
      this.placeInfo = place;
      if(this.placeInfo.places == null) {
        this.placeInfo.places = List();
      } else {
        this.placeInfo = place;
      }
      completer.complete(this.placeInfo);
    })
    .catchError((error){
      completer.completeError(error);
    });

    

    return completer.future;
  }

  void add(LatLng posi) {
    this.placeInfo.places.add(posi);
    setPlaceLocal(this.placeInfo);
  }

  void remove(LatLng pos) {
    this.placeInfo.places.removeWhere((item){
      return pos.latitude == item.latitude && pos.longitude == item.longitude;
    });
    setPlaceLocal(this.placeInfo);
  }

  List<LatLng> getList() {
    return this.placeInfo.places;
  }

  PlaceInfo convertInfoToPlace(Info info) {
    return new PlaceInfo.fromInfo(info);
  }


  Future<void> setPlaceLocal(PlaceInfo place) async {

    Info info = await infoRepository.selectOne("place_info");
    if(info == null) {
      await infoRepository.insert(place.toInfo());
      return;
    }
    
    await infoRepository.update(place.toInfo());
  }

}