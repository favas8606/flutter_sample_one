// ignore_for_file: prefer_function_declarations_over_variables, non_constant_identifier_names, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_1/EmailSender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late final String? mobile;
   late bool isloading ;
   late String verificationId;
   late String phoneNumber;
  //  late int forceResendingToken;
   late String otpCode;
    

  @override
  void initState() {
    onVerifyPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     final  routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // verificationId = routeArgs['verificationId'];
    phoneNumber = routeArgs['phoneNumber'];
    // forceResendingToken = routeArgs['forceResendingToken'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
           
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: const EdgeInsets.only(top:28, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTP(first: true, last: false),
                        _textFieldOTP(first: false, last: false),
                        _textFieldOTP(first: false, last: false),
                        _textFieldOTP(first: false, last: false),
                        _textFieldOTP(first: false, last: false),
                        _textFieldOTP(first: false, last: true),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveData,
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Verify',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Resend New Code",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({bool? first, last}) {
    return SizedBox(
      height: 70,
      width: 50,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
           
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.purple),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }


Future<void> signInwithOTP() async {
    log('sign in otp contr');
    isloading = true;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode.toString(),
    );
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      final IdTokenResult idTokenResult = await user.getIdTokenResult(true);
      final String token = idTokenResult.token!;
    
      saveData();
    } catch (e) {
   
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid Otp'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
        
        ));
      log('Invalid OTP');
      isloading = false;
    }
  }


  void saveData() async {
    SharedPreferences login = await SharedPreferences.getInstance();
    await login.setBool("login", true);
    navigateToHomePage();
  }

  void navigateToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AddminMaillSend()),
        (route) => false);
  }
  Future<void> onVerifyPhoneNumber() async {
    bool isFinished = false;
    
      log('valid');
      isloading = true;
      // ignore: always_specify_types
      await Future.delayed(const Duration(seconds: 1));
      try {
   
         final FirebaseAuth auth = FirebaseAuth.instance;
        log('get started try');
        await auth
            .verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            log('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          },
          
          codeSent: (String verificationId, [int? forceResendingToken]) {
            log('force resending token $forceResendingToken');
            log('code sent');
            var verificationid = verificationId;
            log(phoneNumber);
         

                           isFinished = true;
          },
          
          codeAutoRetrievalTimeout: (String verificationId) {
            log('verificationId  $verificationId');
            log('Timwout');
            log('Phone code auto-retrieval timed out. Verification ID: $verificationId');
          },
        )
            .catchError((dynamic e) {
          log('catch err get started $e');
        });

      
        isloading = false;
      } catch (e) {
        log('get started verify catch $e');
      }
    }
  }

