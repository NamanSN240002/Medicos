import 'package:http/http.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoctorLocation{

  late String diagnosis;
  List<Map<dynamic,dynamic>> hospitallist=[];
  DoctorLocation({required this.diagnosis});

  Future<void> populate_list() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      Fluttertoast.showToast(msg:"Please turn your location on");
    }
    permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        Fluttertoast.showToast(msg: "Location Permission is denied");
      }
    }
    if(permission==LocationPermission.deniedForever){
      Fluttertoast.showToast(msg: "Permission is denied forever");
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    String lat = position.latitude.toString();
    String lon = position.longitude.toString();
    String loc = "$lat, $lon";
    Response response = await post(
      Uri.parse('http://10.0.2.2:5000/listDoctors'),
      headers:<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "search_string":diagnosis,
        "location":loc
      }),
    );
    var output = json.decode(response.body);
    var list = output;
    list.forEach((element)=>{
      hospitallist.add(element)
    });
  }
}