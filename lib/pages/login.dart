import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb1/components/utils.dart';
import 'package:jb1/main.dart';
import 'package:jb1/pages/createaccount.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: const SizedBox(height: 110),
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
            child: const SizedBox(height: 25),
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
          // SizedBox(
          //   width: 250,
          //   child: TextFormField(
          //     controller: trackingNum,
          //     cursorColor: Colors.black,
          //     style: const TextStyle(color: Colors.black),
          //     keyboardType: TextInputType.name,
          //     // inputFormatters: <TextInputFormatter>[
          //     //   // for below version 2 use this
          //     //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //     //   // for version 2 and greater youcan also use this
          //     //   FilteringTextInputFormatter.digitsOnly
          //     // ],
          //     decoration: const InputDecoration(
          //         labelText: "Tracking Number",
          //         labelStyle: TextStyle(color: Colors.black)),
          //     validator: (value) {
          //       if (value == null || value.isEmpty) {
          //         return 'Please enter some text';
          //       }
          //       return null;
          //     },
          //   ),
          // ),
          Container(
            child: const SizedBox(height: 30),
          ),
          Container(
            width: sw / 1.5,
            child: ElevatedButton(
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () async {
                signIn();
              },
            ),
          ),
          Container(
            child: SizedBox(height: 10),
          ),
          Container(
            width: sw / 1.5,
            child: InkWell(
              child: Text(
                "Forgot Password?",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onTap: () async {},
            ),
          ),
          Container(
              width: sw / 1.5,
              child: InkWell(
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => createaccount()));
                },
              )),
        ]),
      ),
    );
  }

  Future signIn() async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(
    //           child: CircularProgressIndicator(),
    //         ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
