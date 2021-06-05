import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yellow_class/cubits/auth.dart';
import 'package:yellow_class/screens/home.dart';
import 'package:yellow_class/screens/login.dart';
import 'package:yellow_class/util/boot_config.dart';
import 'package:yellow_class/util/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthCubit _authCubit = AuthCubit();
  @override
  void initState() {
    super.initState();
    handleAppStart();
  }

  Future<void> handleAppStart() async {
    handleBoot().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              _authCubit.isUserLoggedIn() ? LoginScreen() : HomeScreen(),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Splash',
            style: heading,
          ),
        ),
      ),
    );
  }
}
