import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb1/components/utils.dart';
import 'package:jb1/data/api.dart';
import 'package:jb1/main.dart';
import 'package:jb1/pages/home.dart';
import 'package:jb1/pages/login.dart';
import 'package:http/http.dart' as http;

class password extends StatefulWidget {
  const password({super.key});

  @override
  State<password> createState() => _passwordState();
}

String? setPass;
String? email;

class _passwordState extends State<password> {
  final formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  // Firebase firestore
  final CollectionReference account =
      FirebaseFirestore.instance.collection('user_accounts');
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // InitState

  void initState() {
    super.initState();

    db
        .collection('user_accounts')
        .where('phonenumber', isEqualTo: phnum.toString())
        .orderBy("created_at", descending: true)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        Users data = Users(
          id: docSnapshot.id,
          firsname: docSnapshot.data()['firstname'],
          lastname: docSnapshot.data()['lastname'],
          email: docSnapshot.data()['email'],
          phone: docSnapshot.data()['phonenumber'],
        );

        // print(docSnapshot.data()['password']);

        setState(() {
          setPass = docSnapshot.data()['password'];
          email = docSnapshot.data()['email'];
        });
      }
    });
  }

  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
      width: 100,
      height: 400,
      child: Column(children: [
        Container(
          child: SizedBox(height: 25),
        ),
        Container(
          child: Text(
            'User Credentials',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
          child: SizedBox(height: 50),
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
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email.toString(), password: password.text.trim());
              } catch (e) {
                print(e);
                Utils.showSnackBar(e.toString());
              }

              Navigator.pop(context);

              bool isCorrectPassword =
                  BCrypt.checkpw(password.text, setPass.toString());
              // print(isCorrectPassword);

              // if (isCorrectPassword == true) {
              //   // var url = Uri.parse('/generateCustomToken');
              //   // var response = await http.post(url,
              //   //     headers: {'Content-Type': 'application/json'},
              //   //     body: '{"data": "$uid"}');

              //   // if (response.statusCode == 200) {
              //   //   print('Data sent to server successfully.');
              //   // } else {
              //   //   print(
              //   //       'Failed to send data to server. Status code: ${response.statusCode}');
              //   // }

              // } else {
              //   Navigator.push(
              //       context, MaterialPageRoute(builder: (context) => login()));
              // }
            },
          ),
        ),
        Container(
          child: SizedBox(height: 20),
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
