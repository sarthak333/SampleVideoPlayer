import 'package:firebase_core/firebase_core.dart';

Future<void> handleBoot() async {
  await Firebase.initializeApp();
}
