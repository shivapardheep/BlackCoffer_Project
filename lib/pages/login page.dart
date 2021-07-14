import 'package:blackcoffer_project/pages/OPT%20page.dart';
import 'package:blackcoffer_project/pages/home%20page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _verificationId;

  ////
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: _size.height * 0.50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://raw.githubusercontent.com/afgprogrammer/Flutter-Login-Page-UI/master/assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      height: _size.height * 0.23,
                      width: _size.width * 0.30,
                      left: _size.height * 0.05,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://raw.githubusercontent.com/afgprogrammer/Flutter-Login-Page-UI/master/assets/images/light-1.png')),
                        ),
                      ),
                    ),
                    Positioned(
                      height: _size.height * 0.15,
                      width: _size.width * 0.20,
                      left: _size.width * 0.50,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://raw.githubusercontent.com/afgprogrammer/Flutter-Login-Page-UI/master/assets/images/light-2.png')),
                        ),
                      ),
                    ),
                    Positioned(
                      height: _size.height * 0.25,
                      width: _size.width * 0.20,
                      left: _size.width * 0.70,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://raw.githubusercontent.com/afgprogrammer/Flutter-Login-Page-UI/master/assets/images/clock.png')),
                        ),
                      ),
                    ),
                    Positioned(
                      top: _size.height * 0.28,
                      left: _size.width * 0.35,
                      child: Container(
                        child: Text(
                          'Mobile',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(),
                child: Container(
                  height: 100,
                  child: Image(
                    image: NetworkImage(
                        'https://media.glassdoor.com/sqll/2260916/blackcoffer-squarelogo-1560777778494.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: _size.height * 0.05,
                    horizontal: _size.width * 0.10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(),
                      child: Form(
                        key: _formkey,
                        child: TextFormField(
                          style: TextStyle(),
                          // key: _formkey,
                          controller: _controller,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: '',
                            prefix: Padding(
                              padding: EdgeInsets.all(3),
                              child: Text('+91'),
                            ),
                            hintText: 'Enter Mobile Number',
                            border: OutlineInputBorder(),
                            labelText: 'Enter Mobile Number',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Your Mobile Number..';
                            } else if (value.toString().length != 10) {
                              return 'Please Enter Valid Mobile Number';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        width: _size.width * 0.780,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(143, 148, 251, 1)),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                // loginuser();
                                await _auth
                                    .verifyPhoneNumber(
                                  phoneNumber: '+91${_controller.text}',
                                  verificationCompleted:
                                      (PhoneAuthCredential) async {},
                                  verificationFailed:
                                      (verificationFailed) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(verificationFailed
                                                .message
                                                .toString())));
                                  },
                                  codeSent:
                                      (verificationId, resendingToken) async {
                                    setState(() {
                                      _verificationId = verificationId;
                                      print(
                                          'verification id is : $_verificationId');
                                    });
                                  },
                                  codeAutoRetrievalTimeout:
                                      (verificationId) async {},
                                )
                                    .whenComplete(() {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OPTPage(
                                                  verificationid:
                                                      _verificationId
                                                          .toString(),
                                                  numberph: _controller.text,
                                                )));
                                  });
                                });
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => OPTPage(
                                //             phonenum: _controller.text)));
                              }
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
