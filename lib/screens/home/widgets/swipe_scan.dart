import 'package:flutter/material.dart';

class SwipeToScanCard extends StatefulWidget {
  final VoidCallback onSwipeComplete;

  const SwipeToScanCard({
    super.key,
    required this.onSwipeComplete,
  });

  @override
  State<SwipeToScanCard> createState() => _SwipeToScanCardState();
}

class _SwipeToScanCardState extends State<SwipeToScanCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragPosition = 0.0;
  final double _dragThreshold = 0.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void resetSwipe() {
    setState(() {
      _dragPosition = 0.0;
      _animation = Tween<double>(
        begin: 0.0,
        end: 0.0,
      ).animate(_controller);
      _controller.value = 0.0;
    });
  }

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, constraints.maxWidth - 60);
      _animation = Tween<double>(
        begin: 0.0,
        end: _dragPosition / (constraints.maxWidth - 60),
      ).animate(_controller);
      _controller.value = 1.0;
    });
  }

  void _onDragEnd(BoxConstraints constraints) {
    if (_dragPosition > constraints.maxWidth * _dragThreshold) {
      // Complete the swipe animation to the end
      setState(() {
        _animation = Tween<double>(
          begin: _dragPosition / (constraints.maxWidth - 60),
          end: 1.0,
        ).animate(_controller);
        _controller.forward().then((_) {
          _dragPosition = constraints.maxWidth - 60;
          widget.onSwipeComplete();
        });
      });
    } else {
      // Reset the swipe
      setState(() {
        _animation = Tween<double>(
          begin: _dragPosition / (constraints.maxWidth - 60),
          end: 0.0,
        ).animate(_controller);
        _controller.forward().then((_) {
          _dragPosition = 0.0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GestureDetector(
            onHorizontalDragUpdate: (details) => _onDragUpdate(details, constraints),
            onHorizontalDragEnd: (_) => _onDragEnd(constraints),
            child: Stack(
              children: [
                // Background
                Container(
                  width: maxWidth,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2C5282).withOpacity(0.1), 
                        const Color(0xFF2C5282).withOpacity(0.05)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Swipe to Scan QR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C5282),
                      ),
                    ),
                  ),
                ),
                // Slider
                Positioned(
                  left: _dragPosition,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 60,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C5282),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                // Instruction
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: 1.0 - (_dragPosition / (maxWidth * 0.5)).clamp(0.0, 1.0),
                    duration: const Duration(milliseconds: 200),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF2C5282),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}