import 'package:flutter/material.dart';
import 'package:weather/data/weather_date.dart';
import 'package:weather/util.dart';

class ItemListViewDate extends StatelessWidget {

  WeatherDate wdate;

  Function onTouch = (String date){};

  ItemListViewDate({Key key, this.wdate, this.onTouch }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String temp =  Util.convertTempKtoC(wdate.temp) +" °C";
    return new MaterialButton(
      height: 60,
      color: Colors.white,
      onPressed: (){
        onTouch(wdate.getDate());
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child:  Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child:  Text(wdate.getDate()),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Image.asset("assets/weather-icon/128/"+Util.getIconLocal(wdate.icon)+".png",
                  height: 40,
                ),
              ),
            ),
            Expanded(
              child: Text(temp),
            )
          
          ],
        ),
      ),
    );
  }

}


class ListViewDate extends StatefulWidget {

  List<WeatherDate> listItems;

  Function onTouch = (String date){};

  ListViewDate({Key key, this.listItems, this.onTouch }) : super(key: key);

  @override
  _ListViewDateState createState() => _ListViewDateState();
}

class _ListViewDateState extends State<ListViewDate> {
 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.listItems.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return new ItemListViewDate(
          wdate: widget.listItems[index],
          onTouch: widget.onTouch,
        );
      },
    );
  }
}