import 'package:flutter/material.dart';
import '../../../models/track.dart';
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
  State<SwipeableCard> createState() => SwipeableCardState();
}

class SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  Offset offset = Offset.zero;
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(controller);

    controller.addListener(() {
      setState(() {
        offset = animation.value;
      });
    });
  }

  void swipeRight() {
    flyOut(true);
  }

  void swipeLeft() {
    flyOut(false);
  }

  void flyOut(bool right) {
    final width = MediaQuery.of(context).size.width;

    animation = Tween(
      begin: offset,
      end: Offset(right ? width * 1.5 : -width * 1.5, offset.dy),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward().then((_) {
      if (right) {
        widget.onLike();
      } else {
        widget.onDislike();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          offset += Offset(details.delta.dx, details.delta.dy);
        });
      },
      onPanEnd: (_) {
        if (offset.dx > 120) {
          flyOut(true);
        } else if (offset.dx < -120) {
          flyOut(false);
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
            onLike: widget.onLike,
            onDislike: widget.onDislike,
          ),
        ),
      ),
    );
  }
}
