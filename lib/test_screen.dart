import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoaded = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _navigateToDashboard();
      } on FirebaseAuthException catch (e) {
        _handleAuthError(e);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        await _auth.signInWithCredential(credential);
        _navigateToDashboard();
      } else {
        setState(() => _error = 'Facebook login failed');
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    setState(() {
      _error = e.message ?? 'An unexpected error occurred';
    });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade400,
              Colors.pink.shade500,
              Colors.red.shade500,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildLoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedOpacity(
      opacity: _isLoaded ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _rippleController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1 * (1 - _rippleController.value)),
                    ),
                  ),
                  Container(
                    width: 80 + 20 * _rippleController.value,
                    height: 80 + 20 * _rippleController.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2 * (1 - _rippleController.value)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome Back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate(
            effects: [
              FadeEffect(duration: 500.ms),
              SlideEffect(begin: Offset(0, 0.1), end: Offset.zero, duration: 500.ms),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return AnimatedOpacity(
      opacity: _isLoaded ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _emailController,
                  labelText: 'Email address',
                  prefixIcon: Icons.email,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),
                _buildSignInButton(),
                if (_error.isNotEmpty) _buildErrorMessage(),
                const SizedBox(height: 16),
                _buildSocialLoginButtons(),
                _buildForgotPasswordButton(),
                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(prefixIcon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _handleEmailSignIn,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.purple.shade600,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Sign in'),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        _error,
        style: const TextStyle(color: Colors.redAccent),
      ),
    ).animate().shake();
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        const Text('Or continue with', style: TextStyle(color: Colors.white))
            .animate()
            .fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialLoginButton(
              icon: Icons.facebook,
              color: Colors.blueAccent,
              onPressed: _signInWithFacebook,
            ),
            const SizedBox(width: 16),
            _socialLoginButton(
              icon: Icons.g_mobiledata,
              color: Colors.redAccent,
              onPressed: _signInWithGoogle,
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
      ],
    );
  }

  Widget _socialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.white,
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.zero,
      ),
      child: Icon(icon, size: 30),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // Navigate to forgot password page
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSignUpSection() {
    return Column(
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: () {
            // Navigate to sign up page
          },
          child: const Text(
            'Sign up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}