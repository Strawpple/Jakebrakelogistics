import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jb1/components/utils.dart';
import 'package:jb1/data/api.dart';
import 'package:jb1/main.dart';
import 'package:jb1/pages/createaccount.dart';
import 'package:jb1/pages/otp.dart';
import 'package:jb1/pages/password.dart';
import 'package:pinput/pinput.dart';

class login extends StatefulWidget {
  const login({super.key});

  static String verify = "";
  static String reAuth = "";
  @override
  State<login> createState() => _loginState();
}

String? phnum;
List fetchPhone = [];
List<Users> setUser = [];
String? hasData;

class _loginState extends State<login> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void initState() {
    super.initState();

    List<Users> user = [];
    List phone = [];

    db
        .collection('user_accounts')
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

        // print(docSnapshot.data()['phonenumber']);

        user.add(data);
        phone.add(docSnapshot.data()['phonenumber']);

        setState(() {
          setUser = user;
          fetchPhone = phone;
        });
      }
    });
  }

  bool isChecked = false;
  bool otpCont = false;
  bool verify = true;
  String? num;
  String? sms;
  String? ctry;
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey();
  final pinController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  get verificationId => null;
  // final email = TextEditingController();
  // final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const _initialCountryCode = 'US';
    var _country =
        countries.firstWhere((element) => element.code == _initialCountryCode);

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
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          )),
          Container(
            child: const SizedBox(height: 25),
          ),
          Container(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                    child: IntlPhoneField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      languageCode: "en",
                      onChanged: (phone) {
                        print(phone.completeNumber);
                        if (phone.number.length >= _country.minLength &&
                            phone.number.length <= _country.maxLength) {
                          setState(() {
                            num = phone.completeNumber;
                          });
                        }
                      },
                      onCountryChanged: (country) {
                        print('Country changed to: ' + country.name);
                        setState(() {
                          ctry = country.name;
                        });
                      },
                    ),
                  ),
                  // Container(
                  //   child: ElevatedButton(
                  //     child: Text('Test'),
                  //     onPressed: () async {
                  //       test();
                  //     },
                  //   ),
                  // ),
                  Container(
                    child: SizedBox(height: 50),
                  ),
                  Container(
                    height: 50,
                    width: sw / 1.5,
                    child: Visibility(
                      visible: verify,
                      child: ElevatedButton(
                        child: const Text(
                          "Verify",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        onPressed: () async {
                          // signIn();
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              phnum = num.toString();
                            });

                            // print(fetchPhone);
                            int index = fetchPhone.indexWhere(
                                (element) => element == num.toString());

                            if (index != -1) {
                              openPassword();
                            } else {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: num.toString(),
                                timeout: const Duration(seconds: 60),
                                // phoneNumber: '+639065178566',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  await auth.signInWithCredential(credential);
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  if (e.code == 'invalid-phone-number') {
                                    print(
                                        'The provided phone number is not valid.');
                                  }
                                },
                                codeSent: (String verificationId,
                                    int? resendToken) async {
                                  login.verify = verificationId;
                                  openOtp();
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: const SizedBox(height: 10),
                  ),
                  Container(
                      child: Visibility(
                          visible: otpCont,
                          child: Column(
                            children: [
                              Container(
                                child: Text('SMS Code'),
                              ),
                              Container(
                                child: SizedBox(height: 10),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.black)),
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                              Container(
                                child: SizedBox(height: 10),
                              ),
                              Container(
                                width: sw / 1.5,
                                child: ElevatedButton(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue),
                                  onPressed: () {
                                    signIn();
                                  },
                                ),
                              ),
                              Container(
                                child: SizedBox(height: 10),
                              ),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                  )
                                ]),
                              )
                            ],
                          ))),
                ]),
              )),
          Container(
            child: SizedBox(height: 10),
          ),
          // Container(
          //   child: ElevatedButton(
          //     child: Text('Test'),
          //     onPressed: () async {
          //       openOtpDialog();
          //     },
          //   ),
          // )
          // Container(
          //   width: sw / 1.5,
          //   child: InkWell(
          //     child: Text(
          //       "Forgot Password?",
          //       style:
          //           TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          //     ),
          //     onTap: () async {},
          //   ),
          // ),
          // Container(
          //     width: sw / 1.5,
          //     child: InkWell(
          //       child: Text(
          //         "Register",
          //         style: TextStyle(
          //             color: Colors.blue, fontWeight: FontWeight.bold),
          //       ),
          //       onTap: () async {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => createaccount()));
          //       },
          //     )),
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
      if (_formKey.currentState!.validate()) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: num.toString(),
          timeout: const Duration(seconds: 60),
          // phoneNumber: '+639065178566',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verificationId, int? resendToken) async {
            try {
              String smsCode = pinController.text;
              // String smsCode = '123456';
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

              // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential);
            } catch (e) {
              print(e);
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //     email: email.text.trim(), password: password.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future openOtp() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return otp();
            }),
          );
        }).then((value) => {
          setState(() {
            sms = value;
          })
        });
  }

  Future openPassword() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return password();
            }),
          );
        }).then((value) => {
          setState(() {
            sms = value;
          })
        });
  }

  Future test() async {}
}
