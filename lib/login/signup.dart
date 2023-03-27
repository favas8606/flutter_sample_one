import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool otp = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          Center(
            child: TextFormField(
              controller: mobile,
              autofocus: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          Center(
            child: TextFormField(
              controller: password,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusColor: Colors.green,
                prefixIcon: const Icon(
                  Icons.password,
                  color: Colors.blue,
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
          Center(
            child: TextFormField(
              controller: confrm,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusColor: Colors.green,
                prefixIcon: const Icon(
                  Icons.password,
                  color: Colors.blue,
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
          Center(
            child: ElevatedButton(
              child: const Text("sign up"),
              onPressed: () {
                checkAccuracy();
              },
            ),
          )
        ]),
      ),
    );
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
    print("Hello");
    mobile.clear();
    password.clear();
    confrm.clear();
    userName.clear();
  }

  void checkAccuracy() async {
    if (userName.text.length > 4 &&
        password.text == confrm.text &&
        password.text.length >= 8) {
      sendToDatabase();
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
