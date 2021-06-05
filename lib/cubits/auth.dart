import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:yellow_class/main.dart';
import 'package:yellow_class/models/auth_state.dart';
import 'package:yellow_class/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yellow_class/screens/splash.dart';

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
      Validators.maxLength(6),
      Validators.minLength(6),
    ]),
  });

  bool isUserLoggedIn() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser == null;
  }

  Future<void> sendOtp() async {
    emit(state.copyWith(isPhoneSignInLoading: true));
    String phoneNumber = '+91${phoneNumberForm.value['phone'].toString()}';
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
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
        emit(state.copyWith(
          hasSentOtp: true,
          isPhoneSignInLoading: false,
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        emit(state.copyWith(
          hasSentOtp: true,
          isPhoneSignInLoading: false,
        ));
      },
    );
  }

  Future<void> verifyOtp() async {
    emit(state.copyWith(isPhoneSignInLoading: true));
    String? smsCode = otpForm.value['otp'].toString();
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    auth.signInWithCredential(credential).then((value) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (route) => false,
      );
      emit(state.copyWith(isPhoneSignInLoading: false));
    }).catchError((error) {
      emit(state.copyWith(isPhoneSignInLoading: false));
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

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isGoogleSignInLoading: true));
    try {
      final GoogleSignInAccount googleUser =
          await GoogleSignIn().signIn() as GoogleSignInAccount;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (route) => false,
        );
        emit(state.copyWith(isGoogleSignInLoading: false));
      }).catchError((error) {
        emit(state.copyWith(isGoogleSignInLoading: false));
        Fluttertoast.showToast(
          msg: 'Something went wrong! Please try again later.',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } catch (error) {
      emit(state.copyWith(isGoogleSignInLoading: false));
    }
  }

  Future<void> handleLogout() async {
    FirebaseAuth.instance.signOut().then((value) async {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      if (await _googleSignIn.isSignedIn()) {
        _googleSignIn.signOut();
      }
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SplashScreen()),
          (route) => false);
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Something went wrong! Please try again later.',
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}
