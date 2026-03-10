import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../features/musics/models/music_model.dart';

class TrackImageCard extends StatelessWidget {
  final TrackModel? track;
  final bool isPlaying;
  final VoidCallback? onTap;

  static const _overlayColor = Color(0x99000000); // Colors.black @ 60%

  const TrackImageCard({super.key, this.track, this.isPlaying = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final track = this.track;

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  if (track != null && track.imageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: track.imageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: (_, __) => const ColoredBox(
                        color: Color(0xFF424242),
                        child: Center(
                          child: Icon(Icons.music_note,
                              color: Colors.white54, size: 40),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const ColoredBox(
                        color: Color(0xFF424242),
                        child: Center(
                          child: Icon(Icons.broken_image,
                              color: Colors.white54, size: 40),
                        ),
                      ),
                    )
                  else
                    const ColoredBox(
                      color: Color(0xFF424242),
                      child: Center(
                        child: Icon(Icons.music_note,
                            color: Colors.white54, size: 40),
                      ),
                    ),

                  // Bottom-left track name overlay
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: _overlayColor,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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