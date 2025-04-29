import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  // TODO: implement widget
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/Logo/Logo.png', height: 40),
                  Stack(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        color: Colors.red,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
