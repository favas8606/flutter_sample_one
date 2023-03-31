import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendOTPToMobileNumber(String mobileNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // This callback will be called if verification is done automatically, e.g. using a trusted device
        // You can sign in the user using credential, as shown in the other answers
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure, e.g. invalid mobile number
        print('Failed to send OTP: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle successful OTP sent
        print('OTP sent successfully to $mobileNumber');
        // You can save the verificationId for later use, e.g. when verifying the OTP entered by the user
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle OTP timeout, e.g. user took too long to enter OTP
        print('OTP timeout for $mobileNumber');
      },
    );
  }
}
