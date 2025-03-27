import 'package:flutter/material.dart';
import 'dart:math';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<String> _loadingMessages = [
    "Finding the best smartphone deals...",
    "Analyzing specs and performance...",
    "Fetching the latest smartphone trends...",
    "Just a moment... great choices ahead!"
  ];
  String _currentMessage = "";

  @override
  void initState() {
    super.initState();
    
    // Randomly pick a loading message
    _currentMessage = _loadingMessages[Random().nextInt(_loadingMessages.length)];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for a sleek look
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: child,
                );
              },
              child: const CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _currentMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
