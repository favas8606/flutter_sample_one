import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sample_1/homeScreen.dart';
import 'package:sample_1/login/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var mobileNumber = TextEditingController();
  var password = TextEditingController();
  late Map<String, dynamic> user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(top: 28.0),
              child: Center(
                child: Text('Login Page'),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: mobileNumber,
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
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: TextFormField(
                        obscureText: true,
                        controller: password,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusColor: Colors.green,
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.blue,
                          ),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: checkData,
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Row(
                          children: [
                            const Text("If you don't have Account? "),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen()));
                                },
                                child: const Text("Sign up"))
                          ],
                        ),
                      ),
                    ),
                  ]))
        ],
      ),
    ));
  }

  void checkData() async {
    FirebaseFirestore.instance
        .collection('Accounts')
        .where('Number', isEqualTo: mobileNumber.text)
        .get()
        .then((snapShort) async {
      if (snapShort.docs.isNotEmpty) {
        user = snapShort.docs[0].data();
        print(user);
        if (password.text == user['Password']) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScrren()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text(' entered password is wrong '),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text('entered number is wrong'),
        ));
      }
    });
  }

  void errorMessage() {}
}
