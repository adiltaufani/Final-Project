import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String firstname, String lastname) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _firestore.collection('Users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
      });

      return credential.user;
    } catch (e) {
      print('Some error occured');
    }

    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      //create user
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info
      _firestore.collection('Users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
      });

      return credential.user;
    } catch (e) {
      print('Some error occurred: $e');
    }

    return null;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      // Setelah berhasil logout, navigasi ke halaman login
      Navigator.pushReplacementNamed(context, '/login-screen');
    } catch (error) {
      print("Error during sign out: $error");
      // Tambahkan penanganan kesalahan sesuai kebutuhan
    }
  }
}
