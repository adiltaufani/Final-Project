import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/common/firebase/services/firebase_auth_service.dart';
import 'package:flutter_project/variables.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/features/home/screens/home_screen.dart';

class AuthService {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential =
          await auth.signInWithProvider(googleProvider);

      User? user = userCredential.user;

      if (user != null) {
        // Login berhasil, lakukan navigasi ke screen berikutnya atau tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login berhasil: ${user.email}'),
          ),
        );
        // Navigasi ke screen berikutnya jika diperlukan
        // Navigator.pushReplacementNamed(context, '/home');
        print('Google login berhasil');
      }
    } catch (e) {
      print('Error during Google sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal: $e'),
        ),
      );
    }
  }

  Future<void> _registerUser(
      String uid, String firstName, String lastName, String email) async {
    var url = Uri.parse("${ipaddr}/ta_projek/crudtaprojek/register.php");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nama': '$firstName $lastName',
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'uid': uid,
      }),
    );

    var data = json.decode(response.body);
    if (data == "Error") {
      print("User already exists");
    } else {
      print("Registration successful");
    }
  }

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    User? user = await _auth.signUpWithEmailAndPassword(
        email, password, firstName, lastName);
    if (user != null) {
      Navigator.pushNamed(context, HomeScreen.routeName);
      _registerUser(user.uid, firstName, lastName, email);
      print("Successfully created");
    } else {
      print('Some error occurred');
    }
  }

  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      Navigator.pushNamed(context, HomeScreen.routeName);
      print("Successfully signed in");
    } else {
      print('Some error occurred');
      Fluttertoast.showToast(
        msg: "Incorrect email or password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
