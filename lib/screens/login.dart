import 'dart:developer';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: absoluteWhite,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                'Login',
                style: heading,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  child: BlocBuilder<AuthCubit, AuthState>(
                    bloc: _authCubit,
                    builder: (context, state) {
                      log(state.toJson().toString());
                      return Row(
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
                                              BorderRadius.circular(8),
                                          child: ReactiveTextField(
                                            formControlName: 'otp',
                                            decoration:
                                                inputDecoration.copyWith(
                                              hintText: 'OTP',
                                              hintStyle: hintText,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ReactiveFormConsumer(
                                        builder: (context, form, child) {
                                          return ElevatedButton(
                                            child: Container(
                                              height: 46,
                                              child: Center(
                                                child: Text(
                                                  'Verify',
                                                ),
                                              ),
                                            ),
                                            onPressed: form.valid
                                                ? _authCubit.verifyOtp
                                                : null,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : ReactiveForm(
                                  key: Key('phoneInput'),
                                  formGroup: _authCubit.phoneNumberForm,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: ReactiveTextField(
                                            formControlName: 'phone',
                                            decoration:
                                                inputDecoration.copyWith(
                                              hintText: 'Phone number',
                                              hintStyle: hintText,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ReactiveFormConsumer(
                                        builder: (context, form, child) {
                                          return ElevatedButton(
                                            child: Container(
                                              height: 46,
                                              child: Center(
                                                child: Text(
                                                  'Get OTP',
                                                ),
                                              ),
                                            ),
                                            onPressed: form.valid
                                                ? _authCubit.sendOtp
                                                : null,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
    );
  }
}
