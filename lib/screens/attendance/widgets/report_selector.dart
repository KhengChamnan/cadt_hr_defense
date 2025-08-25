import 'package:flutter/material.dart';

class ReportSelector extends StatelessWidget {
  final String title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  
  const ReportSelector({
    super.key, 
    required this.title,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SizedBox(
        height: 24,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Title text - centered
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // Previous button - positioned on the left
            Positioned(
              left: 0,
              child: SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ),
            ),
            
            // Next button - positioned on the right
            Positioned(
              right: 0,
              child: SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 