import 'package:flutter/material.dart';
import 'package:thyecommercemobileapp/services/auth_service.dart';

class Homepage extends StatelessWidget {
  AuthService _authService = AuthService();
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authService.signOut();
          },
          child: Text('Signout'),
        ),
      ),
    );
  }
}
