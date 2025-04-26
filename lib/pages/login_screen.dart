import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/components/mybutton.dart';
import 'package:thyecommercemobileapp/pages/singup_screen.dart';
import 'package:thyecommercemobileapp/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthService _authService = AuthService();

  bool isLoading = false;
  bool isVisible = false;

  // call the login funciton

  void login() async {
    // Loading has started
    setState(() {
      isLoading = true;
    });
    String result =
        (await _authService.logIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ))!;
    // Loading has completed
    setState(() {
      isLoading = false;
    });

    // then redirect the logged in user based on his status

    if (result == "Admin") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logged in as Admin succesfully')));
    } else if (result == "User") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logged in Succefully!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Image.asset('assets/PageImages/loginPageImage.png'),
                SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: isVisible,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon:
                          isVisible
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                    ),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Mybutton(text: 'Login', onTap: login),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
