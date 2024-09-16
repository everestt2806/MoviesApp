import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isObscure1 = true;
  bool _isObscure2 = true;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _nameError;
  String? _usernameError;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8;
  }

  bool isValidName(String name) {
    return name.length >= 2;
  }

  bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }

  void validateField(String field) {
    setState(() {
      switch (field) {
        case 'email':
          _emailError = _validateEmail(_emailController.text);
          break;
        case 'password':
          _passwordError = _validatePassword(_passwordController.text);
          break;
        case 'confirmPassword':
          _confirmPasswordError = _validateConfirmPassword(_confirmPasswordController.text);
          break;
        case 'name':
          _nameError = _validateName(_nameController.text);
          break;
        case 'username':
          _usernameError = _validateUsername(_usernameController.text);
          break;
      }
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!isValidPassword(value)) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!isValidName(value)) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (!isValidUsername(value)) {
      return 'Username must be 3-20 characters long and contain only letters, numbers, and underscores';
    }
    return null;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String rawPassword = _passwordController.text.trim();
      String name = _nameController.text.trim();
      String userName = _usernameController.text.trim();

      String avatarURL = "https://i.pinimg.com/736x/4a/4c/29/4a4c29807499a1a8085e9bde536a570a.jpg";

      String hashedPassword = sha256.convert(utf8.encode(rawPassword)).toString();

      try {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
        await usersRef.push().set({
          'email': email,
          'username': userName,
          'password': hashedPassword,
          'name': name,
          'dateCreated': ServerValue.timestamp,
          'avatar': avatarURL,
          'accountType': "Premium"
        });
        print('adoaw');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (kDebugMode) {
          print('Error registering user: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registering user: $e')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? errorText,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? (label == "Password" ? _isObscure1 : _isObscure2) : false,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: Icon(icon, color: Colors.black, size: 18),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            label == "Password"
                ? (_isObscure1 ? Icons.visibility : Icons.visibility_off)
                : (_isObscure2 ? Icons.visibility : Icons.visibility_off),
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              if (label == "Password") {
                _isObscure1 = !_isObscure1;
              } else {
                _isObscure2 = !_isObscure2;
              }
            });
          },
        )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        switch (label) {
          case "Email":
            return _validateEmail(value);
          case "Password":
            return _validatePassword(value);
          case "Confirm Password":
            return _validateConfirmPassword(value);
          case "Full Name":
            return _validateName(value);
          case "Username":
            return _validateUsername(value);
          default:
            return null;
        }
      },
      onChanged: onChanged,
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text("Register",
                        style: TextStyle(color: Colors.white, fontSize: 40)),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 1300),
                    child: Text("Create your account",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          FadeInUp(
                            duration: Duration(milliseconds: 1400),
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _emailController,
                                  label: "Email",
                                  icon: FontAwesomeIcons.envelope,
                                  errorText: _emailError,
                                  onChanged: (value) => validateField('email'),
                                ),
                                SizedBox(height: 20),
                                _buildTextField(
                                  controller: _nameController,
                                  label: "Full Name",
                                  icon: FontAwesomeIcons.signature,
                                  errorText: _nameError,
                                  onChanged: (value) => validateField('name'),
                                ),
                                SizedBox(height: 20),
                                _buildTextField(
                                  controller: _usernameController,
                                  label: "Username",
                                  icon: FontAwesomeIcons.user,
                                  errorText: _usernameError,
                                  onChanged: (value) => validateField('username'),
                                ),
                                SizedBox(height: 20),
                                _buildTextField(
                                  controller: _passwordController,
                                  label: "Password",
                                  icon: FontAwesomeIcons.lock,
                                  isPassword: true,
                                  errorText: _passwordError,
                                  onChanged: (value) => validateField('password'),
                                ),
                                SizedBox(height: 20),
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  label: "Confirm Password",
                                  icon: FontAwesomeIcons.lock,
                                  isPassword: true,
                                  errorText: _confirmPasswordError,
                                  onChanged: (value) => validateField('confirmPassword'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              child: MaterialButton(
                                onPressed: _register,
                                height: 50,
                                minWidth: 200,
                                color: Colors.purple[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text("Register",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          FadeInUp(
                            duration: Duration(milliseconds: 1700),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Already have an account? Login",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}