import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AddDiagnosis{
  late String diagnosis;
  late String userid;
  Map<dynamic,dynamic> ret={};
  AddDiagnosis({required this.diagnosis,required this.userid});
  Future<void> addDiagnosis() async{
    Response response = await put(
      Uri.parse('http://10.0.2.2:5000/diagnosis'),
      headers:<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "userid":userid,
        "diagnosis":diagnosis,
        "dateTime":DateTime.now().toString()
      }),
    );
    ret = jsonDecode(response.body);
  }


}