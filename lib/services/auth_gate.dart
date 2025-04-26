import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthGateState();
  }
}

class _AuthGateState extends State<AuthGate> {
  User? currentUser;
  String? userRole;

  @override
  void initState() {
    super.initState();
  }

  void intializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (mounted) return;
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold();
  }
}
