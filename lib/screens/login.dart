import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:yellow_class/cubits/auth.dart';
import 'package:yellow_class/models/auth_state.dart';
import 'package:yellow_class/util/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthCubit _authCubit = AuthCubit();
  bool isSigningInWithPhone = false;

  void _startSignInWithPhone() {
    setState(() {
      isSigningInWithPhone = true;
    });
  }

  void _resetSignInOption() {
    setState(() {
      isSigningInWithPhone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: isSigningInWithPhone
          ? IconButton(
              icon: Icon(
                Icons.chevron_left_sharp,
                color: absoluteBlack,
              ),
              onPressed: _resetSignInOption,
            )
          : null,
      backgroundColor: absoluteWhite,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Column(
                      children: [
                        Text(
                          'Login',
                          style: heading,
                        ),
                        Text('Demo app by Sarthak Jha'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        child: BlocBuilder<AuthCubit, AuthState>(
                          bloc: _authCubit,
                          builder: (context, state) {
                            return isSigningInWithPhone
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      state.hasSentOtp
                                          ? ReactiveForm(
                                              key: Key('otpInput'),
                                              formGroup: _authCubit.otpForm,
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 150,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: ReactiveTextField(
                                                        formControlName: 'otp',
                                                        decoration:
                                                            inputDecoration
                                                                .copyWith(
                                                          hintText: 'OTP',
                                                          hintStyle: hintText,
                                                        ),
                                                        validationMessages:
                                                            (control) => {
                                                          'required':
                                                              "Can't be empty",
                                                          'maxLength':
                                                              'Exceeds 6 digits',
                                                          'minLength':
                                                              'Lesser than 6 digits',
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  ReactiveFormConsumer(
                                                    builder:
                                                        (context, form, child) {
                                                      return !state
                                                              .isPhoneSignInLoading
                                                          ? ElevatedButton(
                                                              child: Container(
                                                                height: 46,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Verify',
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: form
                                                                      .valid
                                                                  ? _authCubit
                                                                      .verifyOtp
                                                                  : null,
                                                            )
                                                          : CircularProgressIndicator();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : ReactiveForm(
                                              key: Key('phoneInput'),
                                              formGroup:
                                                  _authCubit.phoneNumberForm,
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 150,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: ReactiveTextField(
                                                        formControlName:
                                                            'phone',
                                                        decoration:
                                                            inputDecoration
                                                                .copyWith(
                                                          hintText:
                                                              'Phone number',
                                                          hintStyle: hintText,
                                                        ),
                                                        validationMessages:
                                                            (control) => {
                                                          'required':
                                                              "Can't be empty",
                                                          'maxLength':
                                                              'Exceeds 10 digits',
                                                          'minLength':
                                                              'Lesser than 10 digits',
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  ReactiveFormConsumer(
                                                    builder:
                                                        (context, form, child) {
                                                      return !state
                                                              .isPhoneSignInLoading
                                                          ? ElevatedButton(
                                                              child: Container(
                                                                height: 46,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Get OTP',
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: form
                                                                      .valid
                                                                  ? _authCubit
                                                                      .sendOtp
                                                                  : null,
                                                            )
                                                          : CircularProgressIndicator();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      !state.isGoogleSignInLoading
                                          ? ElevatedButton(
                                              child: Text(
                                                'Sign in with Google',
                                              ),
                                              onPressed:
                                                  _authCubit.signInWithGoogle,
                                            )
                                          : CircularProgressIndicator(),
                                      if (Platform.isAndroid)
                                        !state.isPhoneSignInLoading
                                            ? OutlinedButton(
                                                child: Text(
                                                  'Sign in with Phone number',
                                                ),
                                                onPressed:
                                                    _startSignInWithPhone,
                                              )
                                            : CircularProgressIndicator(),
                                    ],
                                  );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
