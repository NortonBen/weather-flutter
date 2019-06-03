
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/weather_info_detail.dart';
import 'package:weather/util.dart';

class DetailView extends StatefulWidget {
  WeatherInfoDetail detail;

  DetailView({Key key, this.detail}) : super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {

    if(widget.detail.icon == null) {
      return Scaffold(
        body: Column(
          children: <Widget>[]
        )
      );
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
         
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Center(
                      child: 
                        Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Image.asset("assets/weather-icon/512/"+Util.getIconLocal(widget.detail.icon)+".png"),
                        )
                    ),
                    color: Colors.white ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(Util.convertTempKtoC(widget.detail.temp)+" °C",
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.3),
                          ),
                        ),
                        Center(
                          child: Text(widget.detail.getTimeShow()+" tại "+ widget.detail.city,
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child:Center(
                            child: Text(widget.detail.getHour() + " , " + Util.getDescription(widget.detail.description),
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    color: Colors.white ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text("Nhiệt độ: "+ Util.convertTempKtoC(widget.detail.temp_min) +" °C - "+ Util.convertTempKtoC(widget.detail.temp_max)+" °C",
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Center(
                            child: Text("Độ ẩm: "+widget.detail.humidity.toString()+"%",
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    color: Colors.white 
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child:  Center(
                            child: Text("Gió: "+widget.detail.wind.toString()+" m/s",
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child:Center(
                            child: Text("Mây: "+widget.detail.cloud.toString()+"%",
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    color: Colors.white 
                  ),
                ),
              ]
            ),
          ),
        ],
      ) 
    );
  }
}