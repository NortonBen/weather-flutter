
import 'package:flutter/material.dart';
import 'package:weather/data/weatherHour.dart';
import 'package:weather/util.dart';

class ItemListViewHour extends StatelessWidget {

  WeatherHour whour;

  Function onTouch = (int dt){};

  ItemListViewHour({Key key, this.whour, this.onTouch }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    String temp = Util.convertTempKtoC(whour.temp) +" °C";
    return new MaterialButton(
      height: 100,
      color: Colors.white,
      onPressed: (){
        onTouch(whour.dt);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset("assets/weather-icon/128/"+Util.getIconLocal(whour.icon)+".png",
                height: 40,
              ),
            ),
            Text(temp),
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child:  Text(whour.getTime()),
            ),
          ],
        ),
      ),
    );
  }
}


class ListViewHour extends StatefulWidget {

  List<WeatherHour> listItems;

  Function onTouch = (int dt){};

  ListViewHour({Key key, this.listItems, this.onTouch }) : super(key: key);

  @override
  _ListViewHourState createState() => _ListViewHourState();
}

class _ListViewHourState extends State<ListViewHour> {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
          bottom: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
        ),
      ),
      child:  ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.listItems.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return ItemListViewHour(
            whour: widget.listItems[index],
            onTouch: widget.onTouch
          );
        },
      ),
      height: 100,

    );
  }
}