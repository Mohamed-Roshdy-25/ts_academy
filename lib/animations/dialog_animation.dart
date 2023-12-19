import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  final Widget child;

  const AnimatedDialog({key, required this.child});

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Dialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(16)),
        child: widget.child,
      ),
    );
  }
}
