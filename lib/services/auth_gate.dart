import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thyecommercemobileapp/pages/homepage.dart';
import 'package:thyecommercemobileapp/pages/login_screen.dart';

class AuthGate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthGateState();
  }

  const AuthGate({super.key});
}

class _AuthGateState extends State<AuthGate> {
  User? _currentUser;
  String? _userRole;

  @override
  void initState() {
    intializeAuthState();
    super.initState();
  }

  void intializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
      // if the user exists find the its infromation
      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (!mounted) return;
        if (userDoc.exists) {
          setState(() {
            _userRole = userDoc['role'];
          });
        }
      }
    });
  }

  @override
  Widget build(context) {
    // return Scaffold();

    //if the current user is null meaning logged out or did not signed up so return the loging screen

    if (_currentUser == null) {
      return LoginScreen();
    }
    if (_userRole == null) {
      return Center(child: CircularProgressIndicator());
    }
    // to keep the user logged in

    return _userRole == 'Admin' ? Homepage() : Homepage();
  }
}
