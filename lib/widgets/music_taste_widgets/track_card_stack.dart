import 'package:flutter/material.dart';
import '../../../models/track.dart';
import 'card/swipe_card.dart';
import 'card/swipeable_card.dart';


class TrackCardStack extends StatelessWidget {
  final List<Track> tracks;
  final GlobalKey<SwipeableCardState> swipeKey;
  final Function(Track, bool) onSwipe;

  const TrackCardStack({
    super.key,
    required this.tracks,
    required this.swipeKey,
    required this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: tracks.asMap().entries.map((entry) {
        final index = entry.key;
        final track = entry.value;

        if (index == tracks.length - 1) {
          return SwipeableCard(
            key: swipeKey,
            track: track,
            onLike: () => onSwipe(track, true),
            onDislike: () => onSwipe(track, false),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SwipeCard(
            key: ValueKey(track.id),
            track: track,
            onLike: () {},
            onDislike: () {},
          ),
        );
      }).toList(),
    );
  }
}