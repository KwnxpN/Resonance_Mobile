import 'package:flutter/material.dart';

class CardActions extends StatelessWidget {
  const CardActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleButton(Icons.close, Colors.redAccent),
        _circleButton(Icons.star, Colors.blueAccent),
        _circleButton(Icons.favorite, Colors.pinkAccent, size: 70),
      ],
    );
  }

  Widget _circleButton(IconData icon, Color color, {double size = 56}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
