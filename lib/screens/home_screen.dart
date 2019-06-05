import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/data/meta_weather.dart';
import 'package:weather/data/weather.dart';
import 'package:weather/data/weatherHour.dart';
import 'package:weather/data/weather_date.dart';
import 'package:weather/data/weather_info_detail.dart';
import 'package:weather/services/service.dart';
import 'package:weather/util.dart';
import 'package:weather/views/detail_view.dart';
import 'package:weather/views/list_view_date.dart';
import 'package:weather/views/list_view_hour.dart';
import 'dart:convert' as JSON;

class HomeScreen extends StatefulWidget {

  List<WeatherHour> listHour;

  List<WeatherDate> listDate ;

  MetaWeather _metaWeather;

  WeatherInfoDetail detail;

  final Service service;

  bool _isLoading = true;

  HomeScreen({Key key, this.service}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<Weather> _loadData() async {
    if(widget.service.appService.option.type == 1) {
      await widget.service.appService.getCoord();
    }
    Weather weather = await widget.service.weatherService.getWeatherAPI(
      lat: widget.service.appService.option.lat,
      log: widget.service.appService.option.log,
    );
    return weather;
  }

  Future<Weather> _loadDataLocal() async {
    // String json = await rootBundle.loadString('assets/data.json');
    // Map<String, dynamic> map = JSON.jsonDecode(json);
    // Weather weather = Weather.fromMap(map);
    Weather weather = await widget.service.weatherService.getWeatherLocal();
    return weather;
  }

  _loadDataToMeta() {
    widget.listDate = widget._metaWeather.listDate;
    widget.detail = widget._metaWeather.getDetailNow(Util.dateNow());
    widget.listHour = widget._metaWeather.getHour(Util.dateNow());
  }

  _handerData(Weather weather) {
    if(weather == null) {
      return;
    }
    setState(() {
      widget._metaWeather = new MetaWeather(weather);
      this._loadDataToMeta();
      widget._isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  void _init() {
    var futl = _loadDataLocal();
    futl.then(_handerData);
    
    var fut = _loadData();
    fut.then(_handerData);
  }

  void _selectHour(int dt) {
    setState(() {
      widget.detail = widget._metaWeather.getDetail(widget.detail.getDate(), dt);
    });
  }

  void _selectDate(String date) {
    setState(() {
      widget.listHour = widget._metaWeather.getHour(date);
      widget.detail = widget._metaWeather.getDetail(date, 0);
    });
  }

  _refreshWeather() {
    setState(() {
      widget._isLoading = true;
    });
    var fut = _loadData();
    fut.then(_handerData);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.detail == null){
      _init();
    }

    Widget buildScreen() {
      if(widget._isLoading) {
        var modal = new Stack(
          children: [
            new Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            new Center(
              child: new CircularProgressIndicator(),
            ),
          ],
        );
        return modal;
      }
      return Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child:  DetailView(detail: widget.detail ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListViewHour(
                      listItems:  widget.listHour,
                      onTouch: _selectHour,  
                    ),
                    Expanded(
                      child: ListViewDate(
                        listItems:  widget.listDate,
                        onTouch: _selectDate,  
                      )
                    )
                  ],
                ),
            )
          ],
        );
    }
    
    return SafeArea(
      child: Scaffold(
        drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
              new ListTile(
                leading:  Icon(Icons.map),
                title: new Text('Bản Đồ'),
                onTap: () {
                  Navigator.pushNamed(context, '/map');
                },
              ),
              // new ListTile(
              //   leading:  Icon(Icons.map),
              //   title: new Text('Địa Điểm'),
              //   onTap: () {
              //     Navigator.pushNamed(context, '/place');
              //   },
              // ),
              new ListTile(
                leading:  Icon(
                  IconData(0xe8b8, fontFamily: 'MaterialIcons')
                ),
                title: Text('Cài đặt'),
                onTap: () {
                  Navigator.pushNamed(context, '/setting');
                },
              ),
              new Divider(),
              new ListTile(
                leading:  Icon(Icons.info),
                title: new Text('Thông tin'),
                onTap: () {
                  Navigator.pushNamed(context, '/info');
                },
              ),
            ],
          )
        ),
        body: buildScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: _refreshWeather,
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}