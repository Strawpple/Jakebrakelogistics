import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jb1/pages/login.dart';

class createaccount extends StatefulWidget {
  const createaccount({super.key});

  @override
  State<createaccount> createState() => _createaccountState();
}

class _createaccountState extends State<createaccount> {
  final formKey = GlobalKey<FormState>();
  // Firebase firestore
  final CollectionReference account =
      FirebaseFirestore.instance.collection('user_accounts');

  // Text Controller
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final contact = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: formKey,
      child: Column(children: [
        Container(
          child: const SizedBox(height: 80),
        ),
        Container(
          child: Image.asset("lib/assets/jb1.png"),
        ),
        Container(
          child: const SizedBox(
            height: 10,
          ),
        ),
        Container(
            child: const Center(
          child: Text(
            "Jakebrake Logistics",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        )),
        Container(
          child: const SizedBox(height: 5),
        ),
        Container(
          child: const Center(
            child: Text(
              "Create Account",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          child: const SizedBox(
            height: 10,
          ),
        ),
        Container(
          width: sw / 1.5,
          child: TextFormField(
            controller: firstname,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "First Name"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Container(
          width: sw / 1.5,
          child: TextFormField(
            controller: lastname,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "Last"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Container(
          width: sw / 1.5,
          child: TextFormField(
            controller: contact,
            cursorColor: Colors.white,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Phone Number"),
            inputFormatters: <TextInputFormatter>[
              // for below version 2 use this
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              // for version 2 and greater youcan also use this
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
        Container(
          width: sw / 1.5,
          child: TextFormField(
            controller: email,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "Email"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
          ),
        ),
        Container(
          width: sw / 1.5,
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
          child: const SizedBox(height: 10),
        ),
        Container(
          width: sw / 1.9,
          child: ElevatedButton(
            child: Text(
              "Create Account",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              signUp();
            },
          ),
        ),
        Container(
          width: sw / 1.9,
          child: ElevatedButton(
            child: Text(
              "Back",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        )
      ]),
    )));
  }

  Future signUp() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    Map<String, dynamic> data = {
      'firstname': firstname.text,
      'lastname': lastname.text,
      'phonenumber': contact.text,
      'email': email.text,
      // 'password': password.text,
      'created_at': date,
    };

    if (formKey.currentState!.validate()) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      account.add(data);

      ElegantNotification.success(
        width: 360,
        notificationPosition: NotificationPosition.topLeft,
        animation: AnimationType.fromTop,
        title: Text('Register'),
        description: Text('Registration Successful!'),
        onDismiss: () {},
      ).show(context);

      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    }
  }
}
