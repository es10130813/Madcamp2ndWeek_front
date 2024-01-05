import 'package:flutter/material.dart';

import 'model/api.dart';


class CreateData extends StatefulWidget {
  const CreateData({super.key});

  @override
  State<CreateData> createState() => _CreateDateState();
}

class _CreateDateState extends State<CreateData>{
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter your ID',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          ElevatedButton(onPressed: (){
            var data = {
              "name" : nameController.text,
              "email" : emailController.text,
              "password" : passwordController.text
            };
            Api.adduser(data);

          }, child: Text("create"))
        ],
      )
    );
  }


}