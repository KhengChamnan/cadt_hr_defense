import 'dart:core';
import 'dart:ui';
import 'package:palm_ecommerce_mobile_app_2/screens/splash/test/splash_screen_test2.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/auto_dismiss_dialog.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/bottom_navigator.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/error_handler.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({Key? key}) : super(key: key);

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.saveCredentials(
        name: _nameController.text, password: _passwordController.text);
  }

  Future<void> clear() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.clearCredentials();
  }

  rememberMe() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      var myValue = await authProvider.getSavedCredentials();
      
      if (mounted) {
        setState(() {
          _nameController.text = myValue['name'] ?? '';
          _passwordController.text = myValue['password'] ?? '';
          _rememberMe = myValue['name'] != null && myValue['password'] != null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> doLogin() async {
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      try {
        await authProvider.login(
            name: _nameController.text, password: _passwordController.text);

        // Only save/clear credentials after successful login
        if (authProvider.isLoggedIn) {
          if (_rememberMe) {
            await save();
          } else {
            await clear();
          }
          
          // Navigate only after all operations are complete
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          // Show user-friendly error message using the utility class
          final friendlyError = ErrorHandler.getUserFriendlyErrorMessage(e);
          AutoDismissDialog.showError(
            context: context,
            title: 'Login Failed',
            message: friendlyError,
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Call rememberMe after the widget is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rememberMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final authValue = authProvider.authState;
    
    switch (authValue.state) {
      case AsyncValueState.loading:
        return const SplashScreenTest2();
      case AsyncValueState.error:
        return _buildLoginScreen(context, 
          errorMessage: ErrorHandler.getUserFriendlyErrorMessage(authValue.error));
      case AsyncValueState.success:
        return _buildLoginScreen(context, errorMessage: null);
    }
  }

  Widget _buildLoginScreen(BuildContext context, {String? errorMessage}) {
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
      child: Column(
        children: [
          const SizedBox(height: 150),
          // Main container with glassmorphism effect
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: 382,
              height: 547, // Increased height to accommodate the warning stripe
              child: Stack(
                children: [
                  // Background rectangle with blur effect
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.3),
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 59.27, sigmaY: 59.27),
                          child: Container(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AC0D)))
                        : Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              // Logo
                              Center(
                                child: Image.asset(
                                  'assets/images/palm_logo.png',
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                              
                              const SizedBox(height: 27),
                              
                              // Name Text
                              const Padding(
                                padding: EdgeInsets.only(left: 7.0),
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontFamily: 'Kokoro',
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Name Field
                              Container(
                                width: 362,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 19.0),
                                  child: TextFormField(
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontFamily: 'Kokoro',
                                      fontSize: 20,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Kokoro',
                                        fontSize: 20,
                                        color: const Color(0xFFD4AC0D).withOpacity(0.6),
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 7),
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 18),
                              
                              // Password Text
                              const Padding(
                                padding: EdgeInsets.only(left: 7.0, top: 20.0),
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    fontFamily: 'Kokoro',
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Password Field
                              Container(
                                width: 362,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(
                                            fontFamily: 'Kokoro',
                                            fontSize: 20,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Kokoro',
                                              fontSize: 20,
                                              color: const Color(0xFFD4AC0D).withOpacity(0.6),
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(vertical: 7),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                        child: Icon(
                                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                          color: const Color(0xFFD4AC0D),
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Remember me checkbox
                              Padding(
                                padding: const EdgeInsets.only(left: 7.0, top: 25.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: const Color(0xFFD4AC0D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFFD4AC0D),
                                          width: 1.5,
                                        ),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    const Text(
                                      'Remember me!',
                                      style: TextStyle(
                                        fontFamily: 'Kokoro',
                                        fontSize: 10,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Login Button
                              Container(
                                width: 362,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AC0D),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: _isLoading ? null : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await doLogin();
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: 'Kokoro',
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              if (errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Center(
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              

                              ],
                            ),
                          ),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          
          const SizedBox(height: 10),
          
          // Welcome text at bottom
          Text(
            'Welcome to PALM',
            style: TextStyle(
              fontFamily: 'Kadwa',
              fontSize: 14,
              color: const Color(0xFFFFD700).withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 30),
        ],
        ),
      ),
    );
  }
}

class StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintYellow = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    
    final paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    // Fill background with yellow
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintYellow);
    
    // Draw black stripes
    double stripeWidth = 15; // Reduced stripe width
    double gap = 15; // Gap between stripes
    
    // Calculate how many stripes we need
    int numStripes = (size.width / (stripeWidth + gap) * 2).ceil();
    
    for (int i = -numStripes; i < numStripes; i++) {
      double xOffset = i * (stripeWidth + gap);
      
      final path = Path();
      path.moveTo(xOffset, 0);
      path.lineTo(xOffset + stripeWidth, 0);
      path.lineTo(xOffset + stripeWidth + size.height, size.height);
      path.lineTo(xOffset + size.height, size.height);
      path.close();
      
      canvas.drawPath(path, paintBlack);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
