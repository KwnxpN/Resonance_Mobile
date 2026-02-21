import 'package:flutter/material.dart';
import '../models/track.dart';
import 'swipe_card.dart';

class SwipeableCard extends StatefulWidget {
  final Track track;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const SwipeableCard({
    super.key,
    required this.track,
    required this.onLike,
    required this.onDislike,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          offset += Offset(details.delta.dx, 0);
        });
      },
      onPanEnd: (_) {
        if (offset.dx > 120) {
          widget.onLike();
          setState(() {
            offset = Offset.zero;
          });
        } else if (offset.dx < -120) {
          widget.onDislike();
          setState(() {
            offset = Offset.zero;
          });
        } else {
          setState(() {
            offset = Offset.zero;
          });
        }
      },
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: offset.dx * 0.002,
          child: SwipeCard(
            track: widget.track,
          ),
        ),
      ),
    );
  }
}
