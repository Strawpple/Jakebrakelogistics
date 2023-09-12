import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jb1/components/utils.dart';
import 'package:jb1/main.dart';
import 'package:jb1/pages/createaccount.dart';
import 'package:jb1/pages/otp.dart';
import 'package:pinput/pinput.dart';

class login extends StatefulWidget {
  const login({super.key});

  static String verify = "";
  @override
  State<login> createState() => _loginState();
}

String? phnum;

class _loginState extends State<login> {
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
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  Container(
                    width: sw / 1.5,
                    child: Visibility(
                      visible: verify,
                      child: ElevatedButton(
                        child: const Text(
                          "Verify",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        onPressed: () async {
                          // signIn();
                          if (_formKey.currentState!.validate()) {
                            // print("hi");
                            print(num.toString());

                            // setState(() {
                            //   otpCont = true;
                            //   verify = false;
                            // });

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

                            // signIn();
                          }
                        },
                      ),
                    ),
                  ),
                  // Container(
                  //   width: sw / 1.5,
                  //   child: TextFormField(
                  //     controller: email,
                  //     cursorColor: Colors.white,
                  //     textInputAction: TextInputAction.next,
                  //     decoration: InputDecoration(labelText: "Email"),
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     validator: (email) =>
                  //         email != null && !EmailValidator.validate(email)
                  //             ? 'Enter a valid email'
                  //             : null,
                  //   ),
                  // ),
                  // Container(
                  //   width: sw / 1.5,
                  //   child: TextFormField(
                  //     obscureText: true,
                  //     controller: password,
                  //     cursorColor: Colors.white,
                  //     textInputAction: TextInputAction.next,
                  //     decoration: InputDecoration(labelText: "Password"),
                  //     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     validator: (value) => value != null && value.length < 6
                  //         ? 'Enter min. 6 characters'
                  //         : null,
                  //   ),
                  // ),
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

  // Future openOtpDialog() => showDialog(
  //     context: context,
  //     builder: (context) => StatefulBuilder(
  //         builder: (context, setState) => AlertDialog(
  //               title: Text('Test'),
  //               content: CheckboxListTile(
  //                 controlAffinity: ListTileControlAffinity.leading,
  //                 title: Text(
  //                   isChecked ? 'Yes' : 'No',
  //                   style: TextStyle(fontSize: 24),
  //                 ),
  //                 value: isChecked,
  //                 onChanged: (isChecked) =>
  //                     setState(() => this.isChecked = isChecked!),
  //               ),
  //             )));

  //  Productions
  Future<bool> verifyOTP(String otp) async {
    var credentials = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: pinController.text));
    return credentials.user != null ? true : false;
  }

  Future codeFunc() async {
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
  }
}
