import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/login_screen.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/singup_screen.dart';
import 'package:thyecommercemobileapp/services/auth_gate.dart';
import 'firebase_options.dart';

ThemeData theme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF4CAF50), // Green 500 (main color)
    onPrimary: Colors.white, // Text/icon color on top of primary color
    secondary: Color(0xFF81C784), // Light green (nice for accents)
    onSecondary: Colors.black, // Text/icon on secondary color
    error: Color(0xFFCF6679), // Standard error color for dark mode
    onError: Colors.black, // Text/icon on error background
    surface: Color(
      0xFF121212,
    ), // Main background (almost black but not full black)
    onSurface: Colors.white, // Text/icon color on surface
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: AuthGate()),
      ),
    );
  }
}
