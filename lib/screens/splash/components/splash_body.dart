import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/auth_wrapper.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({Key? key}) : super(key: key);

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  // Keep track of loading state
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the loading animation
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Add a minimal delay to ensure proper initialization
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthWrapper())
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(
                "assets/images/palm_logo.png",
              ),
              width: 200,
              height: 300,
            ),
            SpinKitThreeBounce(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel timer to prevent callbacks after widget is disposed
    _timer?.cancel();
    super.dispose();
  }
}
