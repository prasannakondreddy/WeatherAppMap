import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'path.dart';
import 'weather.dart';
import 'package:flutter/material.dart';



class Map extends StatefulWidget {
  
  @override
  _MapState createState() => _MapState();
}

  //setting google map
  class _MapState extends State<Map> {
  late GoogleMapController mapController;
  String errorMessage="";

  final List<LatLng> polyPoints = []; 
  final Set<Polyline> polyLines = {};
  final Set<Marker> markers = {};    
  var data;

  //intial and the final locations(_center will be updated when we call getCurrentLocation() function)
  LatLng _center = LatLng(17.437462,78.448288);
  LatLng _des = LatLng(double.parse(inlat),double.parse(inlon));

  static final CameraPosition _InitialPosition =
      CameraPosition(target:LatLng(17.437462,78.448288), zoom: 11.0, tilt: 0, bearing: 0);


  void _onMapCreated(GoogleMapController controller) {
    
    getCurrentLocation();
    mapController = controller;
    setMarkers();
  }

  var geoLocator=Geolocator();

  //getting users current location
  void getCurrentLocation()async{
    try{
    Position res = await Geolocator.getCurrentPosition();
    CameraPosition cameraPosition= new CameraPosition(target:LatLng(res.latitude,res.longitude),zoom: 11);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      _center=LatLng(res.latitude,res.longitude);
      errorMessage="";
    });}catch (error) {
    setState(() {   
      errorMessage=error.toString();
      print(errorMessage);
    });
  }
  }

  //setting markers(location pins)
  setMarkers() {
  markers.add(Marker(
    markerId: MarkerId("Current location"),
    position: LatLng(_center.latitude,_center.longitude),
  ),
  );
  markers.add(Marker(
    markerId: MarkerId("Destination"),
    position: LatLng(_des.latitude,_des.longitude),
  ));
  setState(() {});
  }

  //getting data using path.dart and adding polylines
  void getJsonData() async {
      getPath path = getPath(
      startLat: _center.latitude,
      startLog: _center.longitude,
      endLat: _des.latitude,
      endLog: _des.longitude,
    );

    try {
      // getData() returns a json Decoded data
      data = await path.getData();
      // Reaching JSON data manually 
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue.shade900,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getJsonData();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Map"),
        
          backgroundColor: Colors.blue[800],
        ),
        body: GoogleMap(
          initialCameraPosition: _InitialPosition,
          onMapCreated: _onMapCreated,
          markers: markers,
          polylines: polyLines,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }
}
  
class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
