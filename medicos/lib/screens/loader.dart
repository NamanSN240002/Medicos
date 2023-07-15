import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medicos/services/doctor_list.dart';
import 'package:medicos/services/add_diagnosis.dart';
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Map data = {};
  late var user;
  late var diagnosis;
  void get_Result() async {
    DoctorLocation locInstance = DoctorLocation(diagnosis: diagnosis);
    await locInstance.populate_list();
    AddDiagnosis diaginstance = AddDiagnosis(
        diagnosis: diagnosis, userid: user['id']);
    await diaginstance.addDiagnosis();
    Navigator.pushReplacementNamed(context, '/doctors', arguments: {
      "diagnosis": diagnosis,
      "docList": locInstance.hospitallist,
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // do something
      get_Result();
    });
  }
  @override
  Widget build(BuildContext context) {
    data =  data.isNotEmpty ? data:ModalRoute.of(context)!.settings.arguments as Map;
    user = data['user'];
    diagnosis = data['diagnosis'];
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: const Center(
        child: SpinKitSpinningLines(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}

