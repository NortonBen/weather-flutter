import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/services/service.dart';
import 'package:weather/data/option.dart';

class SettingScreen extends StatefulWidget {

  final Service service;

  LatLng postion = LatLng(-34,151);

  SettingScreen({Key key, this.service}) : super(key: key) {
    this.postion = LatLng(this.service.appService.option.lat, this.service.appService.option.log);
    if(this.postion.latitude == null || this.postion.longitude == null) {
      this.postion = LatLng(-34,151);
    }
    if(this.service.appService.option.type == 1) {
      this.use_map = false;
    } else {
      this.use_map = true;
    }
  }

  bool use_map;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  Completer<GoogleMapController> _controller = Completer();

   void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _createMarker() {
    List<Marker>  list = new List();
    list.add(
      Marker(
        markerId: MarkerId("position"),
        position: this.widget.postion,
      )
    );
    return list.toSet();
  }

  _onTapMap(LatLng position) {
    setState(() {
      this.widget.postion = position;
    });
    this._saveOption();
  }

  _saveOption()  {
    Option option = this.widget.service.appService.option;
    if(this.widget.use_map) {
      option.type = 2;
      option.lat = this.widget.postion.latitude;
      option.log = this.widget.postion.longitude;
      this.widget.service.appService.setOption(option);
    } else {
      this.widget.service.appService.getCoord().then((val){
        option = this.widget.service.appService.option;
        option.type = 1;
        this.widget.service.appService.setOption(option);
        setState(() {
          this.widget.postion = LatLng(this.widget.service.appService.option.lat, this.widget.service.appService.option.log);
        });
      });
    }              
    
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cài Đặt"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child:  Row(
                children: <Widget>[
                  Text("Đựa vào vị trí hiện tại: "),
                  Checkbox(
                    value: !this.widget.use_map,
                    onChanged: (bool value) {
                      setState((){
                        this.widget.use_map = !value;
                      });
                      this._saveOption();
                    },
                  ),
                ],
              )
            )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child:  Row(
                children: <Widget>[
                  Text("Chọn địa điểm trên bản dồ: "),
                  Checkbox(
                        value: this.widget.use_map,
                        onChanged: (bool value) {
                          setState((){
                            this.widget.use_map = value;
                          });
                          this._saveOption();
                        },
                    ),
                ],
              )
            )
          ),
          Expanded(
            flex: 9,
            child: GoogleMap(
              compassEnabled: this.widget.use_map,
              scrollGesturesEnabled: this.widget.use_map,
              zoomGesturesEnabled: this.widget.use_map,
              rotateGesturesEnabled: this.widget.use_map,
              tiltGesturesEnabled: this.widget.use_map,
              myLocationEnabled: true,
              markers: _createMarker(),
              onTap : _onTapMap,
              initialCameraPosition: CameraPosition(
                target: this.widget.postion,
                zoom: 11.0,
              ),
              onMapCreated: _onMapCreated,
            )
          )
        ],
      )
    );
  }
}