// ignore_for_file: use_build_context_synchronously, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AddminMaillSend extends StatefulWidget {
  const AddminMaillSend({Key? key}) : super(key: key);

  @override
  State<AddminMaillSend> createState() => _AddminMaillSendState();
}

class _AddminMaillSendState extends State<AddminMaillSend> {
  var emailController = TextEditingController();
  var messageController = TextEditingController();
  var subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextFormField(
              controller: emailController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Email",
                fillColor: Colors.red,
              ),
            ),
            TextFormField(
              controller: messageController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Message",
                fillColor: Colors.red,
              ),
            ),
            TextFormField(
              controller: subjectController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "subject",
                fillColor: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: sendEmail,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  textStyle: const TextStyle(fontSize: 24)),
              child: const Text("Send Email"),
            ),
          ],
        ));
  }

  Future sendEmail() async {
    final user = await GoolgeAuthApi.signIn();
    if (user == null) {
      return;
    }
    const email = 'favaskzp@gmail.com';
    final auth = await user.authentication;
    final token = auth.accessToken!;
    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = const Address(email, 'favas')
      ..recipients = [emailController.text]
      ..subject = 'This is testing'
      ..text = subjectController.text;
    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Succsess"),
        behavior: SnackBarBehavior.fixed,
      ));
    } on MailerException catch (e) {
      print(e);
    }
  }
}

class GoolgeAuthApi {
  static final _googleSignIn =
      GoogleSignIn(scopes: ['https://mail.google.com/']);
  static Future<GoogleSignInAccount?> signIn() async {
    if (await _googleSignIn.isSignedIn()) {
      return _googleSignIn.currentUser;
    } else {
      return await _googleSignIn.signIn();
    }
  }

  static Future signOut() => _googleSignIn.signOut();
}
