import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/components/my_elevated_button.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_profile/Payment/add_payment.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_profile/Payment/payment_screen.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/login_screen.dart';

class UserProfile extends StatelessWidget {
  final firebasAuth = FirebaseAuth.instance;

  // first get the uid of the current user.
  final uid = FirebaseAuth.instance.currentUser?.uid;
  // now we want to get the user's information like the name and the email from firestore
  CollectionReference userData = FirebaseFirestore.instance.collection('users');
  Widget build(context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.1),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/Logo/userProfile.png'),
                  ),

                  StreamBuilder(
                    stream: userData.doc(uid).snapshots(),
                    builder: (context, snapshots) {
                      if (!snapshots.hasData || !snapshots.data!.exists) {
                        return CircularProgressIndicator();
                      }
                      final user = snapshots.data!;
                      return Column(
                        children: [
                          Text(
                            user['name'],
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryFixedVariant,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            user['email'],
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.black, endIndent: 2, thickness: 1),
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(
                        Icons.change_circle_rounded,
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'Orders',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryFixedVariant,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.payment,
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'Payment Method ',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryFixedVariant,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'About Us',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryFixedVariant,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      firebasAuth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout_outlined,
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'Sign Out ',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryFixedVariant,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
