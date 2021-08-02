
import 'package:flutter/material.dart';
import 'weather.dart';
import 'map.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: WeatherApp(),
      routes: <String,WidgetBuilder>{
        '/Map':(context)=>Map()
      }
    );
  }
}


