import 'package:flutter/material.dart';
import '../models/track.dart';

class CardImage extends StatelessWidget {
  final Track track;

  const CardImage({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Image.network(
            track.image,
            height: 280,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 12,
          right: 16,
          child: Text(track.duration,
              style: const TextStyle(color: Colors.white70)),
        )
      ],
    );
  }
}
