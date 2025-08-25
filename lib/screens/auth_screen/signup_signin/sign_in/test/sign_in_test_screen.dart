import 'package:flutter/material.dart';

class SignInTestScreen extends StatefulWidget {
  const SignInTestScreen({super.key});

  @override
  State<SignInTestScreen> createState() => _SignInTestScreenState();
}

class _SignInTestScreenState extends State<SignInTestScreen> {
  bool rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2C5282), // Dark blue background from Figma
        child: Stack(
          children: [
            // Background elements
            Positioned(
              top: -110,
              left: -203,
              child: Container(
                width: 569,
                height: 377,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(255, 215, 0, 0.3),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 100,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -17,
              child: Container(
                width: 562,
                height: 444,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(255, 215, 0, 0.3),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 100,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
            
            // Main content
            Column(
              children: [
                const Spacer(),
                // Main card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 217, 217, 0.3),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Column(
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/palm_logo.png',
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: 15),
                        
                        // Email label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Kokoro',
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Email input
                        Container(
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
                            padding: const EdgeInsets.symmetric(horizontal: 19),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                  fontFamily: 'Kokoro',
                                  fontSize: 20,
                                  color: const Color(0xFFD4AC0D).withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        
                        // Password label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: 'Kokoro',
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Password input
                        Container(
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
                            padding: const EdgeInsets.symmetric(horizontal: 21),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontFamily: 'Kokoro',
                                  fontSize: 20,
                                  color: const Color(0xFFD4AC0D).withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        
                        // Remember me checkbox
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/remember_icon.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 11),
                            Text(
                              'Remember me!',
                              style: TextStyle(
                                fontFamily: 'Kokoro',
                                fontSize: 10,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  rememberMe = !rememberMe;
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4),
                                  color: rememberMe ? const Color(0xFFD4AC0D) : Colors.transparent,
                                ),
                                child: rememberMe
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),
                        
                        // Login button
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AC0D),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ],
                          ),
                          child: Center(
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
                    color: const Color.fromRGBO(255, 215, 0, 0.7),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}