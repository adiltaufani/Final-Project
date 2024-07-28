import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/common/widgets/custom_password_field.dart';
import 'package:flutter_project/common/widgets/custom_texfield.dart';
import 'package:flutter_project/features/auth/screens/auth_screen.dart';
import 'package:flutter_project/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_project/features/auth/services/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
            SizedBox(
              height: 30,
            ),
            Form(
              key: _signInFormKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: 'E-mail',
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: CustomPasswordField(
                      controller: _passwordController,
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_signInFormKey.currentState!.validate()) {
                          _authService.signIn(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: 'OutfitBlod',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _authService.signInWithGoogle(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 105, vertical: 10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 1.0),
                            child: Image.asset(
                              'assets/images/google-logo.png',
                              width: 26,
                              height: 26,
                            ),
                          ),
                          Text(
                            'Login with Google',
                            style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an accont?",
                        style: TextStyle(
                          fontFamily: 'OutfitBlod',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 10, 97, 141),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AuthScreen.routeName);
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontFamily: 'OutfitBlod',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontFamily: 'OutfitBlod',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0077B2),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ForgotPasswordScreen.routeName);
                        },
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                            fontFamily: 'OutfitBlod',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
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
