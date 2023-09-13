import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jb1/pages/login.dart';
import 'package:pinput/pinput.dart';

class otp extends StatefulWidget {
  const otp({super.key});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  // Firebase firestore
  final CollectionReference account =
      FirebaseFirestore.instance.collection('user_accounts');
  FirebaseAuth auth = FirebaseAuth.instance;
  final pinController = TextEditingController();
  String? smsText;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(children: [
        Container(
          child: const SizedBox(
            height: 20,
          ),
        ),
        Container(
          child: const SizedBox(height: 10),
        ),
        Container(
          child: Text(
            "Verification",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: SizedBox(
            height: 20,
          ),
        ),
        Container(
          child: Text("Enter the OTP send to your phone number"),
        ),
        Container(
          child: SizedBox(
            height: 10,
          ),
        ),
        Container(
          child: Pinput(
            controller: pinController,
            length: 6,
            showCursor: true,
            defaultPinTheme: PinTheme(
                width: 48,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black)),
                textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            onSubmitted: (val) {
              smsText = val;
              print(val);
            },
          ),
        ),
        Container(
          child: SizedBox(height: 15),
        ),
        Container(
            child: ElevatedButton(
                child: Text("Verify"),
                onPressed: () async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: login.verify,
                      smsCode: pinController.text);

                  await auth.signInWithCredential(credential);


                  Navigator.pop(context);
                })),
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Column(children: [
            Container(
              child: Text("Didn't receive any code? "),
            ),
            Container(
              child: InkWell(
                  child: Text(
                'Resend New Code',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            )
          ]),
        )
      ]),
    );
  }
}
