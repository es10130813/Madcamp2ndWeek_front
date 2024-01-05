import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_2nd_week/pages/sign_up_page.dart';
import 'package:madcamp_2nd_week/pages/start_page.dart';

import 'model/api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(),
      routes: {
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final String serverUrl = 'http://143.248.196.88:3000';
  String serverResponse = '';
  int statusCode = 0;
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/'));
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        setState(() {
          serverResponse = response.body;
        });
      } else {
        setState(() {
          serverResponse = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        serverResponse = 'Error: $e';
      });
    }
  }

  Future<void> postData(Map udata) async {
    try {
      print(udata);
      final response = await http.post(
          Uri.parse('$serverUrl/register'),
          body: jsonEncode(udata),
          headers: {"Content-Type": "application/json"},
      );
      statusCode = response.statusCode;
      if (response.statusCode == 201) {
        setState(() {
          serverResponse = response.body;
        });
      } else {
        setState(() {
          serverResponse = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        serverResponse = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter HTTP Request'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Send GET Request'),
            ),
            ElevatedButton(
              onPressed:(){
                var data = {
                  "username" : "aaa",
                  "email" : "hnfa",
                  "password" : "fsdafd"
                };
                postData(data);
              },
              child: Text('Send Post Request'),
            ),
            SizedBox(height: 20),
            Text('Status Code: $statusCode'),
            SizedBox(height: 20),
            Text('Server Response: $serverResponse'),
          ],
        ),
      ),
    );
  }
}