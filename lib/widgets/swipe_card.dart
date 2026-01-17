import 'package:flutter/material.dart';
import '../models/track.dart';
import 'card_image.dart';
import 'card_info.dart';
import 'card_actions.dart';

class SwipeCard extends StatelessWidget {
  final Track track;

  const SwipeCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B0F2F), Color(0xFF120914)],
          ),
        ),
        child: Column(
          children: [
            CardImage(track: track),
            CardInfo(track: track),
            const Spacer(),
            const CardActions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
