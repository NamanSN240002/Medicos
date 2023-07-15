import 'dart:convert';
import 'package:http/http.dart';

class SymptomList{
  late List<String> symptomList;
  Future<void> populate_list() async{
    Response response = await get(Uri.parse('http://10.0.2.2:5000/prediction'));
    var list = json.decode(response.body);
    symptomList = List<String>.from(list['output']);
  }
}

class Prediction{
    late List<String> symptoms;
    late Map<dynamic,dynamic> diagnosis_result;
    Prediction({required this.symptoms});
    Future<void> get_diagnosis() async{
      String data = symptoms.join(',');
      Response response = await post(
          Uri.parse('http://10.0.2.2:5000/prediction'),
          headers:<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        body: jsonEncode(<String, String>{
          'symptoms': data,
        }),
      );
      var list = json.decode(response.body);
      diagnosis_result = list['output'];
    }

}