import 'package:flutter/material.dart';

class CardActions extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const CardActions({
    super.key,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleButton(
          Icons.close,
          Colors.redAccent,
          size: 70,
          onTap: onDislike,
        ),
        _circleButton(
          Icons.favorite,
          Colors.pinkAccent,
          size: 70,
          onTap: onLike,
        ),
      ],
    );
  }

  Widget _circleButton(
    IconData icon,
    Color color, {
    double size = 56,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

