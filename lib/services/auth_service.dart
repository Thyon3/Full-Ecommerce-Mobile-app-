import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get the fire abse auth instance

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get the firestore instance for the database

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // a function to sign up users

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // try to create a user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // save additional data in of the user in firestore like name,email,role

      await _fireStore.collection("users").doc(userCredential.user!.uid).set({
        "name": name.trim(),
        "email": email.trim(),
        "role": role,
      });
      return null; // if null is returned then sign up is succefull
    } catch (e) {
      return e.toString(); // error message is returned
    }
  }

  // login function
  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      // try to sign in the  user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // fetching the role of the user from firestore to determine the level of access

      DocumentSnapshot userDoc =
          await _fireStore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      return userDoc["role"]; //return the role of the signed in user
    } catch (e) {
      return e.toString(); // error message is returned
    }
  }
  // sign out

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
