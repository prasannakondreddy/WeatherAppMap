import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper{
  NetworkHelper({required this.startLng,required this.startLat,required this.endLng,required this.endLat});

final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '5b3ce3597851110001cf6248f043f51ca0d64f788877a0f4bd928e7d';
  final String pathParam = 'driving-car';// Change it if you want
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{
      var Url=Uri.parse('$url$pathParam?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat');
     var response = await http.get(Url);
    

    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);

    }
    else{
      print(response.statusCode);
    }
  }
}