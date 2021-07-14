import 'package:blackcoffer_project/pages/home%20page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OPTPage extends StatefulWidget {
  final String verificationid;
  final String numberph;
  const OPTPage({
    Key? key,
    required this.verificationid,
    required this.numberph,
  }) : super(key: key);

  @override
  _OPTPageState createState() => _OPTPageState();
}

class _OPTPageState extends State<OPTPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String _verificationCode;
  TextEditingController _otpController = TextEditingController();
  var currentText;
  bool _isLoading = false;
  var verificationid;
  var phonenmbr;
  @override
  void initState() {
    // loginuser();
    verificationid = widget.verificationid;
    phonenmbr = widget.numberph;
    super.initState();
  }

  void SignInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authphone =
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _isLoading = false;
      });
      if (authphone.user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            e.message.toString(),
            style: TextStyle(color: Colors.white),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: _size.height * 0.10),
          child: Column(
            children: [
              Container(
                // height: _size.height * 0.40,

                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://sivapardeep.files.wordpress.com/2021/06/otp.png"),
                      fit: BoxFit.fill),
                ),
              ),
              Container(
                // height: _size.height * 0.40,

                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://media.glassdoor.com/sqll/2260916/blackcoffer-squarelogo-1560777778494.png"),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                height: _size.height * 0.01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      'Phone Number Verification',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    SizedBox(
                      height: _size.height * 0.03,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Enter the code sent to ',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                            children: [
                          TextSpan(
                            text: '+91 ${phonenmbr}',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                    PinCodeTextField(
                      textStyle: TextStyle(color: Colors.black),
                      // backgroundColor: Colors.white,
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      // obscuringCharacter: '*',
                      // obscuringWidget: FlutterLogo(
                      //   size: 24,
                      // ),
                      // blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Enter 6 digit OTP";
                        } else {
                          return null;
                        }
                      },
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      // enableActiveFill: true,
                      controller: _otpController,
                      keyboardType: TextInputType.number,

                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                    SizedBox(
                      height: _size.height * 0.03,
                    ),
                    Container(
                      width: _size.width * 0.780,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo,
                      ),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              // _SigninPhoneNumber(_controller.text);
                              final PhoneAuthCredential phoneauth =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationid,
                                      smsCode: _otpController.text);
                              SignInWithPhoneAuthCredential(phoneauth);
                            });
                          },
                          child: Text(
                            'Get Started',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Container(
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {},
                        child: RichText(
                            text: TextSpan(
                                text: 'Did not get otp, ',
                                style: TextStyle(color: Colors.grey[500]),
                                children: [
                              TextSpan(
                                  text: 'resend?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ])),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.indigo[400],
          onPressed: () {},
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // loginuser() async {
  //   try {
  //     _firebaseAuth.verifyPhoneNumber(
  //       phoneNumber: ('+1${widget.verificationid}'),
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await _firebaseAuth.signInWithCredential(credential).then((value) {
  //           if (value.user != null) {
  //             print('Signin SUccessfully');
  //             // onAuthenticationSuccessful();
  //           } else {
  //             print('Signin Not Success');
  //           }
  //         }).catchError((onError) {
  //           setState(() {
  //             print('Error is : $onError');
  //           });
  //         });
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print(e.message);
  //       },
  //       codeSent: (String verificationId, [forresendingToken]) {
  //         setState(() {
  //           _verificationCode = verificationId;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationID) {
  //         setState(() {
  //           _verificationCode = verificationID;
  //         });
  //       },
  //       timeout: Duration(seconds: 60),
  //     );
  //     print('Hi Shiva : ${_verificationCode.length}');
  //   } catch (e) {
  //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>ErrorPage()));
  //   }
  // }
}
