import 'package:firebase_core/firebase_core.dart';

Future<bool> handleBoot() async {
  await Firebase.initializeApp();
  return true;
}
