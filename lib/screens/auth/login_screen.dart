import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies_app/screens/home.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:movies_app/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  int activeIndex = 0;
  final List<String> _images = [
    'assets/img/2798007.png',
    'assets/img/3658959.png',
    'assets/img/movie-masks-emblem-icon-5693166.jpg',
    'assets/img/png-transparent-media-leisure-entertainment-couch-home-livingroom-netflix-and-chill-video-movie-azure-illustration-set-thumbnail.png'
  ];

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _emailError = false;
  bool _passwordError = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        activeIndex = (activeIndex + 1) % _images.length;
      });
    });

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        setState(() {
          _emailError = false;
        });
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _passwordError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    }
    return null;
  }

  // Facebook Sign-In
  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(result.accessToken!.tokenString);
      return (await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)).user;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _emailError = true;
      });
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      setState(() {
        _emailError = true;
      });
      return 'Please enter a valid email';
    }
    setState(() {
      _emailError = false;
    });
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _passwordError = true;
      });
      return 'Please enter your password';
    }
    if (value.length < 6) {
      setState(() {
        _passwordError = true;
      });
      return 'Your password must be at least 6 characters';
    }
    setState(() {
      _passwordError = false;
    });
    return null;
  }

  Future<void> _login() async {
    // Implement login logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.purple[900]!,
              Colors.purple[800]!,
              Colors.purple[400]!
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Welcome Back!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: _images.asMap().entries.map((e) {
                              return Positioned.fill(
                                child: AnimatedOpacity(
                                  duration: Duration(seconds: 1),
                                  opacity: activeIndex == e.key ? 1 : 0,
                                  child: Image.asset(
                                    e.value,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          validator: validateEmail,
                          focusNode: _emailFocusNode,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          validator: validatePassword,
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Forgot Password Action
                              },
                              child: Text("Forgot Password?"),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: _login,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple[900]!,
                                  Colors.purple[800]!,
                                  Colors.purple[400]!
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                              label: Text('Sign in with Google'),
                              onPressed: signInWithGoogle,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                              label: Text('Sign in with Facebook'),
                              onPressed: signInWithFacebook,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[900],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
