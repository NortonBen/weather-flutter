import 'dart:async';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:weather/data/weather.dart';
import 'package:weather/services/service.dart';

import '../util.dart';

class MapScreen extends StatefulWidget {

  final Service service;


  MapScreen({Key key, this.service}) : super(key: key);

  LatLng _center = const LatLng(21.5847151, 105.8055135);

  List<Marker> makes = new List();

  bool is_remove = false;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
     _refresh();
  }


  Set<Marker> _createMarker() {
    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    return this.widget.makes.toSet();
  }

  Future<BitmapDescriptor> _markerIcon(String icon) {
    final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
    return BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/weather-icon/128/"+Util.getIconLocal(icon)+".png");
  }

  _onTapMap(LatLng position) {
    showWeather(position);
    this.widget.service.weatherPlaceService.add(position);
  }


  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
    try {
      homeScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(response.errorMessage)),
      );
    } catch(e) {
      return;
    }
  }

    
  Future<void> _handlePressButton() async {
    try {
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          apiKey: this.widget.service.kGoogleApiKey,
          onError: onError,
          mode: Mode.overlay,
          language: "vn");

      showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future showWeather(LatLng position) {
     Completer completer = new Completer();
    this.widget.service.weatherService.getWeatherAPI(
      lat: position.latitude,
      log: position.longitude,
    ).then((data){
      InfoWeather info = data.list.first;

      _markerIcon(info.weather.icon).then((icon){
        setState(() {
          MarkerId id = MarkerId(data.city.id.toString()+"-"+position.latitude.toString()+"/"+position.longitude.toString());
          this.widget.makes.add(
            Marker(
              markerId: id,
              icon: icon,
              position: position,
              infoWindow: InfoWindow(
                //title: data.city.name+" "+ Util.convertTempKtoC(info.main.temp) +" °C",
                title: Util.convertTempKtoC(info.main.temp) +" °C",
                onTap: (){
                  _tapInMark(id);
                },
              )
            )
          );
          completer.complete();
        });
      }).catchError(completer.completeError);
    });
    return completer.future;
  }
  

  Future showDetailPlace(String placeId) async {
    if (placeId != null) {
      PlacesDetailsResponse place =  await this.widget.service.googleMapsPlaces.getDetailsByPlaceId(placeId);
      if(place.status == "OK") {
        LatLng position = LatLng(
          place.result.geometry.location.lat,   
          place.result.geometry.location.lng,            
        );
       
        showWeather(position).then((NULL) {
          this.widget.service.weatherPlaceService.add(position);
        });
       
      } else {
        print(place.errorMessage);
      }

    
    }
  }

  _refresh() {
    List<LatLng> list = this.widget.service.weatherPlaceService.getList();
    for(var pos in list) {
      showWeather(pos);
    }
  }

  _remove() {
    setState(() {
      this.widget.is_remove = !this.widget.is_remove;
    });
  }

  _tapInMark(MarkerId id) {
    if(this.widget.is_remove) {
      Marker mark = this.widget.makes.singleWhere((item){
        return item.markerId == id;
      });
      setState(() {
        this.widget.makes.remove(mark);
      });
      this.widget.service.weatherPlaceService.remove(mark.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bản Đồ"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refresh();
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            color: this.widget.is_remove? Colors.red : null,
            onPressed: () {
              _remove();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _handlePressButton();
            },
          ),
        ],
      ),
      
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: this.widget._center,
          zoom: 11.0,
        ),
        myLocationEnabled: true,
        markers: _createMarker(),
        onTap : _onTapMap
      ),
    );
  }
}