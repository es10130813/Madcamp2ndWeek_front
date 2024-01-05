import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://143.248.196.88/32/";

  static adduser(Map udata) async{
    print(udata);
    var url = Uri.parse("${baseUrl}register");
    try {

      final res = await http.post(Uri.parse("uri"), body: udata);
      if(res.statusCode == 201){
        var data = jsonDecode(res.body.toString());
        print(data);

      } else {
        print("Failed to get response");
      }
    } catch (e){
      debugPrint(e.toString());
    }
  }
}