import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/Admin/screens/add_items.dart';
import 'package:thyecommercemobileapp/services/auth_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdminHomeScreenState();
  }
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AuthService _authService = AuthService();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome Admin'), centerTitle: true),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authService.signOut();
          },
          child: Text("Logout"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
          weight: 8,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItems()),
          );
        },
      ),
    );
  }
}
