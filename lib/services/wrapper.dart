import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:diary/screens/home.dart';
import 'package:diary/screens/login.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    // ignore: unnecessary_null_comparison
    if (user == null){
      return Login();

    } else {
      return Home();
    }
  }
}
