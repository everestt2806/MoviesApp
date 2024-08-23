import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:movies_app/screens/auth/recovery_password_screen.dart';
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

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        activeIndex = (activeIndex + 1) % _images.length;
      });
    });
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
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(height: 10),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text(
                          "Welcome to Movie App",
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
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                          height: 150,  // Thay đổi chiều cao container
                          width: 150,   // Thêm chiều rộng container
                          child: Stack(
                            children: _images.asMap().entries.map((e) {
                              return Positioned.fill(  // Sử dụng Positioned.fill
                                child: AnimatedOpacity(
                                  duration: Duration(seconds: 1),
                                  opacity: activeIndex == e.key ? 1 : 0,
                                  child: Image.asset(
                                    e.value,
                                    width: 150,  // Thêm chiều rộng
                                    height: 150, // Giữ nguyên chiều cao
                                    fit: BoxFit.contain,  // Thay đổi từ cover sang contain
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Column(
                            children: [
                              TextField(
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    floatingLabelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                obscureText: _isObscure,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                    child: Icon(
                                      _isObscure ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                      color: Colors.grey,
                                      size: 17,
                                    ),
                                  ),
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.key,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 10),
                      FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RecoveryPasswordScreen()),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.blue[900]),
                              ),
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
                            onPressed: () {},
                            height: 50,
                            minWidth: 200,
                            color: Colors.purple[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      FadeInUp(
                          duration: Duration(milliseconds: 1700),
                          child: Text(
                            "Continue with",
                            style: TextStyle(color: Colors.grey),
                          )),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {},
                              height: 50,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.facebook, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Facebook",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {},
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.github,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Github",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          "Register an account.",
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
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