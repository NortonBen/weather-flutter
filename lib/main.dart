import 'package:flutter/material.dart';
import 'package:weather/db/datacontext.dart';
import 'package:weather/repositories/repositories.dart';
import 'package:weather/screens/home_screen.dart';
import 'package:weather/screens/info_screen.dart';
import 'package:weather/screens/map_screen.dart';
import 'package:weather/screens/place_screen.dart';
import 'package:weather/screens/setting_screen.dart';
import 'package:weather/services/service.dart';


void main() async {

  DataContext dbContext = new DataContext();
  await dbContext.getDatabase();

  Repositories repositories = new Repositories(dbContext);

  Service service = new Service(repositories);

  await service.appService.getOption();
  await service.weatherPlaceService.getPlaceLocal();

  if(service.appService.option.type == 1) {
    service.appService.getCoord().then((val){
      print('end');
    });
  }
 

  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In our case, the app will start
    // on the FirstScreen Widget
    initialRoute: '/',
    routes: {
      // When we navigate to the "/" route, build the FirstScreen Widget
      '/': (context) => HomeScreen(service: service),
      // When we navigate to the "/second" route, build the SecondScreen Widget
      '/setting': (context) => SettingScreen(service: service),
      '/info': (context) => InfoScreen(),
      '/map': (context) => MapScreen(service: service),
    },
  ));
}