import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Curved blue background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Opacity(
              opacity: 0.8,
              child: Container(
                height: 206, // Exact height from Figma design
                decoration: const BoxDecoration(
                  color: Color(0xFF117864),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // App bar content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/palm_logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'PALM Technology',
                          textStyle: const TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Using the exact path data from the Figma SVG
    // Original path: "M434.061 159.933C383.167 188.06 305.976 206 219.561 206C132.543 206 54.8787 187.809 4 159.344V0.589844L434.061 0V159.933Z"
    
    Path path = Path();
    
    // Scale factors to fit the path to our container size
    final double scaleX = size.width / 434.061;
    final double scaleY = size.height / 206;
    
    // Start at bottom left
    path.moveTo(0, 0); // Top left corner
    
    // Draw line to the point where curve begins
    path.lineTo(0, 159.344 * scaleY);
    
    // Create the bottom curve
    path.cubicTo(
      54.8787 * scaleX, 187.809 * scaleY, // First control point
      132.543 * scaleX, 206 * scaleY,     // Second control point
      219.561 * scaleX, 206 * scaleY      // End point
    );
    
    // Continue the curve to the right side
    path.cubicTo(
      305.976 * scaleX, 206 * scaleY,     // First control point
      383.167 * scaleX, 188.06 * scaleY,  // Second control point
      size.width, 159.933 * scaleY        // End point (right side)
    );
    
    // Complete the shape
    path.lineTo(size.width, 0); // Top right corner
    path.close(); // Back to start point
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
} 