// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var userName = TextEditingController();
  var mobile = TextEditingController();
  var password = TextEditingController();
  var confrm = TextEditingController();
  bool passwordVisible = false;
  bool confrmVisible = false;
  bool otp = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          Form(
              key: _formKey,
              child: Column(children: [
                const Center(
                  child: Text("Sign Up"),
                ),
                Center(
                  child: TextFormField(
                    controller: userName,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusColor: Colors.green,
                      prefixIcon: const Icon(
                        Icons.verified_user,
                        color: Colors.blue,
                      ),
                      hintText: 'User name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        otp = true;
                        return "Enter valid name";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: TextFormField(
                    controller: mobile,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusColor: Colors.green,
                      prefixIcon: const Icon(
                        Icons.mobile_friendly,
                        color: Colors.blue,
                      ),
                      hintText: 'Number',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length != 10) {
                        otp = true;
                        return "Enter valid number";
                      }
                      return null;
                    },
                  ),
                ),
                otp == true ? TextFormField() : Container(),
                const SizedBox(height: 15),
                Center(
                  child: TextFormField(
                    controller: password,
                    obscureText: !passwordVisible,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusColor: Colors.green,
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      hintText: 'password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return "Make valid password";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: TextFormField(
                    controller: confrm,
                    obscureText: !confrmVisible,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusColor: Colors.green,
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(confrmVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            confrmVisible = !confrmVisible;
                          });
                        },
                      ),
                      hintText: 'Conform password',
                    ),
                    validator: (value) {
                      if (password.text != confrm.text) {
                        return "password doesn't match";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    child: const Text("sign up"),
                    onPressed: () {
                      checkAccuracy();
                    },
                  ),
                )
              ]))
        ]),
      ),
    );
  }

  Future createUserWithMobileNumber(
      String mobileNumber, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: '$mobileNumber@myapp.com',
        password: password,
      );
      sendToDatabase();
    } catch (e) {
      print(e);
    }
  }

  void sendToDatabase() async {
    final username = userName.text;
    final num = mobile.text;
    final pas = password.text;
    final dbValue = Account(
      name: username,
      number: num,
      password: pas,
    );
    await sendData(dbValue);
  }

  sendData(Account dbValue) async {
    final user =
        FirebaseFirestore.instance.collection('Accounts').doc(userName.text);
    final jsonData = dbValue.toJson();
    await user.set(jsonData);
    mobile.clear();
    password.clear();
    confrm.clear();
    userName.clear();
  }

  void checkAccuracy() async {
    if (userName.text.length > 4 &&
        password.text == confrm.text &&
        password.text.length >= 8) {
      createUserWithMobileNumber(mobile.text, password.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text('Enter valid data'),
      ));
    }
  }
}

class Account {
  late final String name;
  late final String number;
  late final String password;
  Account({
    required this.name,
    required this.number,
    required this.password,
  });
  Map<String, dynamic> toJson() => {
        'Name': name,
        'Number': number,
        'Password': password,
      };
}
