import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thyecommercemobileapp/components/my_elevated_button.dart';

class UserProfile extends StatelessWidget {
  final firebasAuth = FirebaseAuth.instance;
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: MyElevatedButton(
            onTap: () {
              firebasAuth.signOut();
            },
            buttonText: 'Logout',
            color: Colors.black38,
          ),
        ),
      ),
    );
  }
}
