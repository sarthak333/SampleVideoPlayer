import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // handleLogin();
  }

  void handleLogin() async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+918896299356',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print(credential);
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        print(verificationId);
        print(resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(),
              Text('Login'),
              ElevatedButton(
                onPressed: handleLogin,
                child: Text('dfs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
