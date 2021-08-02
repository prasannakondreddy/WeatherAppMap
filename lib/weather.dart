import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var inlat="";
var inlon="";
var currlat="";
var currlon="";

class WeatherApp extends StatefulWidget {
@override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String city="Mumbai";
  dynamic temperature=0;
  String des="Clear";
  String errorMessage = '';

  void getData(String input) async{
    try{
   var url=Uri.parse("https://api.openweathermap.org/data/2.5/weather?q="+input+"&appid=7ea3a2790eb7c209c8ec9992f1c736cc");
   var response  =await http.get(url);
   var data = jsonDecode(response.body);
   
    setState(() {
      city=input;
      temperature=(data['main']['temp']-273.5).round();
      des = data['weather'][0]['main'];
      inlat=data['coord']['lat'].toString();
      inlon=data['coord']['lon'].toString();
      errorMessage ='';  
  });
    }catch (error) {
    setState(() {   
      errorMessage =error.toString();
    });    
  }  
} 

  void onTextFieldSubmitted(String input) {
    getData(input);
  }


  @override
  Widget build(BuildContext context) {
    DateTime dateToday =new DateTime.now(); 
    String date = dateToday.toString().substring(0,10);
    return MaterialApp(
        home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/$des.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
            child: Icon(Icons.pin_drop_sharp,color: Colors.red,),
            onPressed:(){
              Navigator.pushNamed(context, '/Map');
            } ,
            backgroundColor:Colors.white),
              backgroundColor: Colors.transparent,
              //backgroundColor: Colors.grey.withOpacity(0.8),
              body: 
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: TextField(
                        autofocus: true,
                        onSubmitted: (String input) {
                                onTextFieldSubmitted(input);
                              },
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Enter city name...',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18.0),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                            padding:
                                const EdgeInsets.only(right: 32.0, left: 32.0),
                            child: Text(errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 18,
                                )
                          )
                            )],
                ),
                Column(
                  children: <Widget>[
                    
                    Center(
                      child: Text(
                        city,
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        date,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        temperature.toString() + ' °C',
                        style: TextStyle(color: Colors.white, fontSize: 67.0),
                      ),
                    ),
                    
                    Center(
                      child: Text(
                        des,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ],
              )
              ]
              ),
          ),
        ));
  }
}