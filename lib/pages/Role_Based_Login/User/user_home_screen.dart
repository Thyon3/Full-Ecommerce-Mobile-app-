import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thyecommercemobileapp/services/auth_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserHomeScreenState();
  }
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome user')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authService.signOut();
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
