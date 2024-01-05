import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>{
  final String serverUrl = 'http://143.248.196.88:3000';
  String signUpResult = '';
  int statusCode = 0;

  var nameController = TextEditingController();
  var idController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> signUp(Map udata) async {
    try {
      print(udata);
      final response = await http.post(
        Uri.parse('$serverUrl/register'),
        body: jsonEncode(udata),
        headers: {"Content-Type": "application/json"},
      );

      statusCode = response.statusCode;
      print(statusCode);
      if (response.statusCode == 201) {
        setState(() {
          signUpResult = "회원가입 성공";
        });
      } else {
        setState(() {
          signUpResult = '중복된 id입니다.';
        });
      }
    } catch (e) {
      setState(() {
        signUpResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea (
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                String? name = nameController.text;
                String? id = idController.text;
                String? password = passwordController.text;

                var data = {
                  "username" : nameController.text,
                  "email" : idController.text,
                  "password" : passwordController.text
                };
                signUp(data);
              },
              child: Text('sign Up'),
            ),
            SizedBox(height: 20),
            Text('회원가입 결과: $signUpResult'),
          ],
        ),

      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
