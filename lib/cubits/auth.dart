import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:yellow_class/main.dart';
import 'package:yellow_class/models/auth_state.dart';
import 'package:yellow_class/screens/home.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  late String _verificationId;

  final phoneNumberForm = FormGroup({
    'phone': FormControl<String>(validators: [
      Validators.required,
      Validators.number,
      Validators.maxLength(10),
      Validators.minLength(10),
    ]),
  });

  final otpForm = FormGroup({
    'otp': FormControl<String>(validators: [
      Validators.required,
      Validators.number,
      Validators.maxLength(6),
      Validators.minLength(6),
    ]),
  });

  bool isUserLoggedIn() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser == null;
  }

  Future<void> sendOtp() async {
    String phoneNumber = '+91${phoneNumberForm.value['phone'].toString()}';
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(
          msg: 'Something went wrong! Please try again later.',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        emit(AuthState(hasSentOtp: true));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        emit(AuthState(hasSentOtp: true));
      },
    );
  }

  Future<void> verifyOtp() async {
    String? smsCode = otpForm.value['otp'].toString();
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    auth.signInWithCredential(credential).then((value) {
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (route) => false);
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Invalid OTP',
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}
