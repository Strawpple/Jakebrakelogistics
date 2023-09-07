import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final trackingNum = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: const SizedBox(height: 110),
          ),
          Container(
            child: Image.asset("lib/assets/JBLLogoColored.png"),
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
                "Tracker",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: const SizedBox(
              height: 25,
            ),
          ),
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: trackingNum,
              cursorColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.name,
              // inputFormatters: <TextInputFormatter>[
              //   // for below version 2 use this
              //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              //   // for version 2 and greater youcan also use this
              //   FilteringTextInputFormatter.digitsOnly
              // ],
              decoration: const InputDecoration(
                  labelText: "Tracking Number",
                  labelStyle: TextStyle(color: Colors.black)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
            child: const SizedBox(height: 20),
          ),
          Container(
            child: ElevatedButton(
              child: const Text("Submit"),
              onPressed: () async {},
            ),
          )
        ]),
      ),
    );
  }
}
