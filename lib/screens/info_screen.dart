import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin"),
      ),
      body:  Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 200),
            child:Center(
              child: Text("Ứng dụng thời tiết",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ),
           Padding(
            padding: EdgeInsets.only(top: 10),
            child:Center(
              child: Text("Đồ án tốt nghiệp ICTU",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child:Center(
              child: Text("Người thực hiện: Đào Thị Nga",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      )
    );
  }
}