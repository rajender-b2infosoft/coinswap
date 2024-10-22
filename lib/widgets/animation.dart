import 'package:flutter/material.dart';

class RotatingIcon extends StatefulWidget {
  @override
  _RotatingIconState createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.sync,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}