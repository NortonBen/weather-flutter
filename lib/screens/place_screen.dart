
import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/services/service.dart';


class PlaceScreen extends StatefulWidget {

  String kGoogleApiKey;
  GoogleMapsPlaces places;
  final Service service;

  List<Marker> markers;

  PlaceScreen({Key key, this.service}) : super(key: key) {
    markers = new List();
    this.kGoogleApiKey = this.service.kGoogleApiKey;
    this.places = this.service.googleMapsPlaces;
  }


  @override
  State<StatefulWidget> createState() {
    return _PlaceScreen();
  }
}

class _PlaceScreen extends State<PlaceScreen> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          title: const Text("PlaceZ"),
          actions: <Widget>[
          
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _handlePressButton();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    markers: this.widget.markers.toSet(),
                    initialCameraPosition:  const CameraPosition(target: LatLng(0.0, 0.0))
                    )                    
            ),
           // Expanded(child: expandedChild)
          ],
        ));
  }


  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void getNearbyPlaces(LatLng center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    setState(() {
      this.isLoading = false;
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    try {
      final center = LatLng(21.5847151, 105.8055135);
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: this.widget.kGoogleApiKey,
          onError: onError,
          mode: Mode.overlay,
          language: "en",
          location: center == null
              ? null
              : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);

      showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async {
    if (placeId != null) {
      PlacesDetailsResponse place =  await this.widget.places.getDetailsByPlaceId(placeId);
      setState(() {
        this.isLoading = false;
        if (place.status == "OK") {
          //place.result.geometry.location.
        }
      });
    }
  }

}
