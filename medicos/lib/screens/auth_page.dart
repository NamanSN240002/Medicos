import 'package:flutter/material.dart';
import 'package:medicos/services/form_service.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Future<String> login(String email,password) async{
    try{
      Response response = await post(
        Uri.parse("http://10.0.2.2:5000/login"),
        headers:<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email':email,
          'password':password,
        }),
      );
      if(response.statusCode==200){
        var info_ = jsonDecode(response.body);
        var user = info_['output'];
        SymptomList instance = SymptomList();
        await instance.populate_list();

        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'symptoms': instance.symptomList,
          'user':user
        });
      }else{
        var info_ = jsonDecode(response.body);
        var emsg = info_['custom'];
        return emsg;
      }
    }
    catch(e){
      return e.toString();
    }
    return "Done";
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medical_services,size: 42,color: Colors.cyan,),
              Text("MEDICOS",style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold,color: Colors.cyan),),
              SizedBox(height:30),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email'
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Password'
                ),
              ),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: () async{
                  var emsg = await login(emailController.text.toString(),passwordController.text.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(emsg)));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text('Login'),
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Text("Dont have an account?"),
              TextButton(onPressed: (){
                Navigator.pushReplacementNamed(context, '/register');
              }, child: Text("Register!")),
            ],
          ),
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Future<String> register(String email,name,password1,password2) async{
    try{
      Response response = await put(
        Uri.parse("http://10.0.2.2:5000/register"),
        headers:<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email':email,
          'password1':password1,
          'password2':password2
        }),
      );
      if(response.statusCode==200){
        var info_ = jsonDecode(response.body);
        var user = info_['output'];
        Navigator.pushReplacementNamed(context, '/loader',arguments: {
          'user':user,
        });
      }else{
        var info_ = jsonDecode(response.body);
        var emsg = info_['custom'];
        return emsg;
      }
    }
    catch(e){
      return e.toString();
    }
    return "Done!";
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medical_services,size: 42,color: Colors.cyan,),
              Text("MEDICOS",style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold,color: Colors.cyan),),
              SizedBox(height:30),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Email'
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Name'
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: passwordController1,
                decoration: InputDecoration(
                    hintText: 'Password'
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: passwordController2,
                decoration: InputDecoration(
                    hintText: 'Confirm Password'
                ),
              ),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: () async{
                  var emsg = await register(emailController.text.toString(),nameController.text.toString(),passwordController1.text.toString(),passwordController2.text.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(emsg)));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text('Sign Up'),
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Text("Already have an account?"),
              TextButton(onPressed: (){
                Navigator.pushReplacementNamed(context, '/');
              }, child: Text("Login!")),
            ],
          ),
        ),
      ),
    );
  }
}
