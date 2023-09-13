import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb1/pages/home.dart';
import 'package:jb1/pages/login.dart';

class information extends StatefulWidget {
  const information({super.key});

  @override
  State<information> createState() => _informationState();
}

class _informationState extends State<information> {
  final formKey = GlobalKey<FormState>();
  // Firebase firestore
  final CollectionReference account =
      FirebaseFirestore.instance.collection('user_accounts');
  // Text Controller
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                child: const SizedBox(height: 80),
              ),
              Container(
                child: Image.asset("lib/assets/jb1.png"),
              ),
              Container(
                child: const SizedBox(
                  height: 20,
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
                child: const SizedBox(height: 10),
              ),
              Container(
                child: Text(
                  "Information",
                  style: TextStyle(fontSize: 20),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter First Name';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Last';
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
                child: const SizedBox(height: 10),
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
                width: sw / 1.5,
                child: ElevatedButton(
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () async {
                    signUp();
                  },
                ),
              ),
              Container(
                width: sw / 1.5,
                child: ElevatedButton(
                  child: Text(
                    "Skip for now",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () async {
                    DateTime now = new DateTime.now();
                    DateTime date = new DateTime(now.year, now.month, now.day);
                    Map<String, dynamic> data = {
                      'firstname': firstname.text,
                      'lastname': lastname.text,
                      'phonenumber': phnum.toString(),
                      'email': email.text,
                      // 'password': password.text,
                      'created_at': date,
                    };
                    ElegantNotification.success(
                      width: 360,
                      notificationPosition: NotificationPosition.topLeft,
                      animation: AnimationType.fromTop,
                      title: Text('Register'),
                      description: Text('Registration Successful!'),
                      onDismiss: () {},
                    ).show(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => home()));
                  },
                ),
              ),
            ],
          )),
    ));
  }

  Future signUp() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    Map<String, dynamic> data = {
      'firstname': firstname.text,
      'lastname': lastname.text,
      'phonenumber': phnum.toString(),
      'email': email.text,
      // 'password': password.text,
      'created_at': date,
    };

    if (formKey.currentState!.validate()) {
      account.add(data);

      ElegantNotification.success(
        width: 360,
        notificationPosition: NotificationPosition.topLeft,
        animation: AnimationType.fromTop,
        title: Text('Register'),
        description: Text('Registration Successful!'),
        onDismiss: () {},
      ).show(context);

      Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
    }
  }
}
