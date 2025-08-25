import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/auth_wrapper.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/responsive.dart';

class SplashScreenTest2 extends StatefulWidget {
  const SplashScreenTest2({super.key});

  @override
  State<SplashScreenTest2> createState() => _SplashScreenTest2State();
}

class _SplashScreenTest2State extends State<SplashScreenTest2>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;
  
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Logo scale animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoController.forward();

    // Fade in text
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _textFadeAnimation = CurvedAnimation(
      parent: _textFadeController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      _textFadeController.forward();
    });

    // Navigate after delay
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthWrapper())
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textFadeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = MobileResponsive.isTablet(context);
          final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
          
          // Calculate responsive dimensions based on available space
          // Use the smaller dimension (height or width) to ensure logo fits in both orientations
          final smallerDimension = isLandscape 
              ? constraints.maxHeight 
              : constraints.maxWidth;
          
          // Adjust logo size to be proportional to the smaller dimension
          // Make logo smaller in landscape to ensure it fits
          final logoSize = isLandscape
              ? smallerDimension * 0.5
              : smallerDimension * (isTablet ? 0.5 : 0.75);
          
          // Scale font sizes based on screen size
          final scaleFactor = isTablet ? 1.2 : 1.0;
          final welcomeFontSize = 24.0 * scaleFactor;
          final titleFontSize = 40.0 * scaleFactor;
          final dotsSize = 40.0 * scaleFactor;
          
          // Create a responsive layout based on orientation
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: isLandscape
                  ? _buildLandscapeLayout(
                      constraints,
                      logoSize,
                      welcomeFontSize,
                      titleFontSize,
                      dotsSize,
                    )
                  : _buildPortraitLayout(
                      constraints,
                      logoSize,
                      welcomeFontSize,
                      titleFontSize,
                      dotsSize,
                      isTablet,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(
    BoxConstraints constraints,
    double logoSize,
    double welcomeFontSize,
    double titleFontSize,
    double dotsSize,
    bool isTablet,
  ) {
    // Calculate spacing as percentage of available height
    final topSpacingPercent = isTablet ? 0.05 : 0.03;
    final topSpacing = constraints.maxHeight * topSpacingPercent;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: topSpacing),
        _buildLogo(logoSize, welcomeFontSize, titleFontSize),
        Expanded(child: _buildLoadingDots(dotsSize)),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BoxConstraints constraints,
    double logoSize,
    double welcomeFontSize,
    double titleFontSize,
    double dotsSize,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 3,
          child: _buildLogo(logoSize, welcomeFontSize, titleFontSize),
        ),
        Expanded(
          flex: 2,
          child: _buildLoadingDots(dotsSize),
        ),
      ],
    );
  }

  Widget _buildLogo(double logoSize, double welcomeFontSize, double titleFontSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ScaleTransition(
                scale: _logoAnimation,
                child: Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/palm_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(top: logoSize * 0.97),
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome To',
                          style: TextStyle(
                            fontFamily: 'Kokoro',
                            fontSize: welcomeFontSize,
                            color: const Color(0xFFFFD700),
                          ),
                        ),
                        Text(
                          'PALM HR',
                          style: TextStyle(
                            fontFamily: 'Kokoro',
                            fontSize: titleFontSize,
                            color: const Color(0xFFFFD700),
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDots(double dotsSize) {
    return Align(
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Kokoro',
          fontSize: dotsSize,
          color: const Color(0xFFD4AC0D),
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              '. . .',
              textStyle: TextStyle(
                fontSize: dotsSize,
                color: const Color(0xFFD4AC0D),
              ),
              colors: const [
                Colors.yellow,
                Colors.amber,
                Colors.orange,
                Colors.yellow,
              ],
              speed: const Duration(milliseconds: 200),
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,
        ),
      ),
    );
  }
}