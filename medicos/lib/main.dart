import 'package:flutter/material.dart';
import 'package:medicos/screens/loader.dart';
import 'package:medicos/screens/auth_page.dart';
import 'package:medicos/screens/home.dart';
import 'package:medicos/screens/mediform.dart';
import 'package:medicos/screens/doctor.dart';

void main()=>runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/loader':(context)=> const Loading(),
    '/':(context)=>const Login(),
    '/register':(context)=>const Register(),
    '/home':(context)=>const Home(),
    '/form':(context)=>const MediForm(),
    '/doctors':(context)=>const DoctorList()
  },
));
