import 'package:flutter/material.dart';
import 'package:yellow_class/screens/login.dart';
import 'package:yellow_class/util/boot_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    handleAppStart();
  }

  Future<void> handleAppStart() async {
    handleBoot().then((value) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Splash'),
        ),
      ),
    );
  }
}
