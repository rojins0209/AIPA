import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Adjusted to a relative path assuming chat_screen.dart is in the same folder

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for a 1-second fade-in and fade-out
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // 1 second total
      vsync: this,
    );

    // Define fade animation: 0 to 1 (fade in), then back to 0 (fade out)
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50, // Fade in for first half
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50, // Fade out for second half
      ),
    ]).animate(_controller);

    // Start the animation
    _controller.forward().then((_) {
      // Navigate to ChatScreen after animation completes
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ChatScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000), // Smooth 0.5s transition
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color((0xFF9C27B0)), // Blue shade
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Uncomment if you have a logo
              // Image.asset(
              //   'assets/logo.png',
              //   width: 120,
              //   height: 120,
              // ),
              // const SizedBox(height: 20),
              const Text(
                'AIPA',
                style: TextStyle(
                  fontSize: 100,
                  fontFamily: 'pacifico',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}