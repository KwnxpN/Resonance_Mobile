import 'package:flutter/material.dart';
import '../models/track.dart';
import 'card_image.dart';
import 'card_info.dart';
import 'card_actions.dart';

class SwipeCard extends StatelessWidget {
  final Track track;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const SwipeCard({
    super.key,
    required this.track,
    required this.onLike,
    required this.onDislike,
  });

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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardImage(track: track),
                CardInfo(track: track),
                const SizedBox(height: 100), // เผื่อพื้นที่ให้ปุ่ม
              ],
            ),

            // Positioned(
            //   bottom: 20,
            //   left: 0,
            //   right: 0,
            //   child: CardActions(
            //     onLike: onLike,
            //     onDislike: onDislike,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
