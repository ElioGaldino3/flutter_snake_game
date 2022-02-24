import 'package:flutter/material.dart';

class GameController extends StatelessWidget {
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const GameController({
    Key? key,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      height: 192,
      child: Row(
        children: [
          GameButton(child: const Icon(Icons.arrow_left_rounded, size: 56, color: Colors.white), onTap: onLeft),
          Column(
            children: [
              GameButton(child: const Icon(Icons.arrow_drop_up_rounded, size: 56, color: Colors.white), onTap: onUp),
              const SizedBox(height: 56),
              GameButton(child: const Icon(Icons.arrow_drop_down_rounded, size: 56, color: Colors.white), onTap: onDown),
            ],
          ),
          GameButton(child: const Icon(Icons.arrow_right_rounded, size: 56, color: Colors.white), onTap: onRight),
        ],
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback onTap;
  const GameButton({
    Key? key,
    this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.black),
        child: Center(child: child),
      ),
    );
  }
}
