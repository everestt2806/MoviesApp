import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movies_app/screens/auth/recovery_password_screen.dart';
import 'package:movies_app/screens/auth/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies_app/main.dart';

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
  bool _formSubmitted = false;
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

  Future<void> saveLoginStatus(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email); // Lưu email của user
  }

// Kiểm tra trạng thái đăng nhập
  Future<String?> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail'); // Trả về email nếu có, nếu không trả về null
  }

// Xóa trạng thái đăng nhập khi người dùng đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail'); // Xóa thông tin user
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
      return 'Please enter the valid email';
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

  Future<void> _submitForm() async {
    setState(() {
      _formSubmitted = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
        final DataSnapshot snapshot = await usersRef.get();
        bool isUserFound = false;

        if (snapshot.exists) {
          Map<String, dynamic> usersMap = Map<String, dynamic>.from(snapshot.value as Map);
          usersMap.forEach((key, value) async {
            if (value['email'] == _emailController.text && value['password'] == _passwordController.text) {
              isUserFound = true;
              print('Đăng nhập thành công');
              print('Thông tin người dùng: $value');

              // Lưu trạng thái đăng nhập bằng email
              await saveLoginStatus(value['email']);

              // Tiếp tục điều hướng tới trang chính của ứng dụng
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()), // Chuyển đến HomeScreen
              );
              return;
            }
          });
        }

        if (!isUserFound) {
          print('Email hoặc mật khẩu không chính xác');
        }
      } catch (e) {
        print('Lỗi: $e');
      }
    }
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
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(height: 10),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text(
                          "Welcome",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Container(
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
                        ),
                        SizedBox(height: 10),
                        FadeInUp(
                            duration: Duration(milliseconds: 1400),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  onChanged: (_) {
                                    setState(() {
                                      _emailError = false;
                                    });
                                  },
                                  validator: validateEmail,
                                  focusNode: _emailFocusNode,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    floatingLabelStyle: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _emailError
                                              ? Colors.red
                                              : Colors.grey.shade200,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _emailError
                                              ? Colors.red
                                              : Colors.black,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  obscureText: _isObscure,
                                  controller: _passwordController,
                                  onChanged: (_) {
                                    setState(() {
                                      _passwordError = false;
                                    });
                                  },
                                  validator: validatePassword,
                                  focusNode: _passwordFocusNode,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
                                    floatingLabelStyle: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _passwordError
                                              ? Colors.red
                                              : Colors.grey.shade200,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _passwordError
                                              ? Colors.red
                                              : Colors.black,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FadeInLeft(
                                      duration: Duration(milliseconds: 1000),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              const RecoveryPasswordScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () {
                                    _submitForm();
                                  },
                                  child: Container(
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 40),
                        FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
