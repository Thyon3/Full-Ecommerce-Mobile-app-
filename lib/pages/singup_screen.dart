import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/components/mybutton.dart';
import 'package:thyecommercemobileapp/pages/login_screen.dart';
import 'package:thyecommercemobileapp/services/auth_service.dart';

class SingupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _signUpScreenState();
  }
}

class _signUpScreenState extends State<SingupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String selectedRole = 'User';
  bool isLoading = false;

  bool isVisible = false;

  final AuthService _authService = AuthService();
  void signUp() async {
    // now the loading process has started so set isLoading to true

    setState(() {
      isLoading = true;
    });
    String? result = await _authService.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: selectedRole,
    );
    // Loading has been completed
    setState(() {
      isLoading = false;
    });

    if (result == null) {
      //sing up succesfull redirect the user to the login screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('sign up successfull! Login to finish')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      //sing up failed
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('sign up failed $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Image.asset('assets/PageImages/signUpPage.png'),
                SizedBox(height: 40),
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
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
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
                  controller: _nameController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  items:
                      ['Admin', 'User'].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedRole = newValue.toString();
                    });
                  },
                ),
                SizedBox(height: 30),
                isLoading
                    ? Mybutton(text: 'Sign Up', onTap: signUp)
                    : Center(child: CircularProgressIndicator()),

                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already registered?",
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
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign in",
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
