import 'package:flutter/material.dart';
import 'package:flutter_project/common/widgets/custom_texfield.dart';
import 'package:flutter_project/features/auth/screens/login_screen.dart';
import 'package:flutter_project/features/auth/services/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_project/common/widgets/custom_password_field.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();

  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _repeatpasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _repeatpasswordController.dispose();
  }

  void _showPasswordErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password harus memiliki minimal 6 karakter.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _showEmailErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email must be valid.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 60),
              child: Text(
                'Book-it',
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Text(
              'Book with Ease, Anytime, Anywhere!',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 370,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _authService.signInWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 105, vertical: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 1.0),
                      child: Image.asset(
                        'assets/images/google-logo.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const Text(
                      'Sign up with Google',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OutfitBlod',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'or',
              style: TextStyle(
                fontFamily: 'OutfitBlod',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Form(
              key: _signUpFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 38, right: 10, top: 10),
                          child: CustomTextField(
                            controller: _nameController,
                            hintText: 'First Name',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 1, right: 38, top: 10),
                          child: CustomTextField(
                            controller: _lastnameController,
                            hintText: 'Last Name',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 38, vertical: 10),
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: 'E-mail',
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 38, vertical: 0),
                    child: CustomPasswordField(
                      controller: _passwordController,
                      hintText: 'Password',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 38, vertical: 10),
                    child: CustomPasswordField(
                      controller: _repeatpasswordController,
                      hintText: 'Repeat password',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_passwordController.text.length < 6) {
                          _showPasswordErrorSnackBar();
                        } else if (!_emailController.text.contains('@')) {
                          _showEmailErrorSnackBar();
                        } else if (_signUpFormKey.currentState!.validate()) {
                          _authService.signUp(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                            firstName: _nameController.text,
                            lastName: _lastnameController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 127, vertical: 10),
                      ),
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: 'OutfitBlod',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontFamily: 'OutfitBlod',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0077B2),
                        ),
                      ),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, LoginScreen.routeName),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'OutfitBlod',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
