import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jb1/pages/login.dart';

class password extends StatefulWidget {
  const password({super.key});

  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  final formKey = GlobalKey<FormState>();
  // Firebase firestore
  final CollectionReference account =
      FirebaseFirestore.instance.collection('user_accounts');
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
      width: 100,
      height: 300,
      child: Column(children: [
        Container(
          child: SizedBox(height: 25),
        ),
        Container(
          child: Text(
            'User Credentials',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: SizedBox(
            height: 15,
          ),
        ),
        Container(
          child: Text(
            phnum.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: SizedBox(height: 15),
        ),
        Container(
          child: TextFormField(
            obscureText: true,
            controller: password,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "Password"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 6
                ? 'Enter min. 6 characters'
                : null,
          ),
        ),
        Container(
          child: SizedBox(height: 25),
        ),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            child: Text(
              'Login',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(primary: Colors.blue),
            onPressed: () async {},
          ),
        ),
        Container(
          child: SizedBox(height: 10),
        ),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        )
      ]),
    );
  }
}
