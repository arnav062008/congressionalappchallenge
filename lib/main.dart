
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/login.dart';

void main() async {
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppChallenge());
}

class AppChallenge extends StatefulWidget {
  const AppChallenge({Key? key}) : super(key: key);

  @override
  State<AppChallenge> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AppChallenge> {
  @override


  Widget build(BuildContext context) {

    return const MaterialApp(
      title: 'Congressional App Challenge',
      home: SignInPage(),
    );
  }
}