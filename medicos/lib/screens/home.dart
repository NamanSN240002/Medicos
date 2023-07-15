import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  Map<dynamic,dynamic> user = {};
  @override
  Widget build(BuildContext context) {
    data =  data.isNotEmpty ? data:ModalRoute.of(context)!.settings.arguments as Map;
    user = data['user'];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Medicos",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.cyan,
        ),
      body: Column(
        children: [
          TextButton(
            onPressed: ()async{
              await Navigator.pushNamed(context, '/form', arguments: {
                'symptoms': data['symptoms'],
                'user':user,
              });
              Response response = await post(
                Uri.parse('http://10.0.2.2:5000/diagnosis'),
                headers:<String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  "userid":user['id'],
                }),
              );
              var res = jsonDecode(response.body);
              setState(() {
                  user['diagnosis'] = res['diagnosis'];
              });
            },
            child: Card(
              color: Colors.cyan,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              elevation: 5.0,
              child: Stack(
                alignment: Alignment.center,
                children:[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/bannerImg.jpg',
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Perform Diagnosis!\t',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0),
                      )),
                ]
              ),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            alignment: AlignmentDirectional.center,
            child: Text(
                "History of Diagnosis",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: user['diagnosis'].length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    color: Colors.cyan.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    elevation: 5.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                              "Diagnosis Result: "+user['diagnosis'][index]['diagnosis'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Diagnosis Time: "+user['diagnosis'][index]['dateTime'],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
