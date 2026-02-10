import 'package:flutter/material.dart';
import '../../features/musics/models/music_model.dart';

class TrackImageCard extends StatefulWidget {
  final TrackModel? track;
  final bool isPlaying;
  final VoidCallback? onTap;

  const TrackImageCard({ super.key, this.track, this.isPlaying = false, this.onTap });

  @override
  State<TrackImageCard> createState() => _TrackImageCardState();
}

class _TrackImageCardState extends State<TrackImageCard> {
  @override
  Widget build(BuildContext context) {
    final track = widget.track;

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  if (track != null && track.imageUrl.isNotEmpty)
                    Image.network(
                      track.imageUrl,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),

                  // Bottom-left track name overlay
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          track?.name ?? 'Unknown Track',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}