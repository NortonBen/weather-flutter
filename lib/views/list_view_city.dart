import 'package:flutter/material.dart';
import 'package:weather/data/city.dart';

class ItemListViewCity extends StatelessWidget {

  City city;

  ItemListViewCity({Key key, this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(city.name, style: TextStyle(fontSize: 22.0),),
        ),
    );
  }

}


class ListViewCity extends StatefulWidget {

  List<City> listItems;

  ListViewCity({Key key, this.listItems}) : super(key: key);

  @override
  _ListViewCityState createState() => _ListViewCityState();
}

class _ListViewCityState extends State<ListViewCity> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài Đặt"),
      ),
      body: new ListView.builder
      (
        itemCount: widget.listItems.length,
        itemBuilder: (BuildContext ctxt, int index) => new ItemListViewCity(city: widget.listItems[index]),
      ),
    );
  }
}