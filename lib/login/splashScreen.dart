// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sample_1/homeScreen.dart';
import 'package:sample_1/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogedAccount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.greenAccent,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkLogedAccount() async {
    await Future.delayed(const Duration(seconds: 3));
    final login = await SharedPreferences.getInstance();
    final logIn = login.getBool("login");
    if (logIn == null || logIn == false) {
      gotoLogin();
    } else {
      gotoHomePage();
    }
  }

  void gotoLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const Login())));
  }

  void gotoHomePage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScrren()));
  }
}
