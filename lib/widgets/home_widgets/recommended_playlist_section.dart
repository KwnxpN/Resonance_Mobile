import 'package:flutter/material.dart';
import '../../features/playlists/models/playlist.dart';
import 'playlist_card.dart';
import 'section_error.dart';

class RecommendedPlaylistSection extends StatelessWidget {
  final Future<PlaylistModel> future;
  final VoidCallback onRetry;
  final VoidCallback onReturn;

  const RecommendedPlaylistSection({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onReturn,
  });

  static const _pink = Color(0xFFCF22A6);
  static const _purple = Color(0xFF6B2FD9);
  static const _deepPurple = Color(0xFF3D1080);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A0A2E),
            Color(0xFF0D0720),
          ],
        ),
        border: Border.all(
          color: _pink.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _pink.withValues(alpha: 0.35),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: _purple.withValues(alpha: 0.25),
            blurRadius: 48,
            spreadRadius: 4,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background aura blobs
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _pink.withValues(alpha: 0.3),
                      _pink.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -20,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _purple.withValues(alpha: 0.25),
                      _purple.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  FutureBuilder<PlaylistModel>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 180,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: _pink,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return SectionError(
                          message: 'Failed to load recommended playlists',
                          onRetry: onRetry,
                        );
                      }

                      if (!snapshot.hasData) {
                        return const SectionError(
                            message: 'No recommended playlists yet');
                      }

                      final playlist = snapshot.data!;

                      return Center(child: _buildGlowCard(playlist));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Glowing icon badge
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_pink, _purple],
            ),
            boxShadow: [
              BoxShadow(
                color: _pink.withValues(alpha: 0.6),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "For You" badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      _pink.withValues(alpha: 0.25),
                      _purple.withValues(alpha: 0.25),
                    ],
                  ),
                  border: Border.all(
                    color: _pink.withValues(alpha: 0.5),
                    width: 0.8,
                  ),
                ),
                child: const Text(
                  '✦  For You',
                  style: TextStyle(
                    fontSize: 10,
                    color: _pink,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Your Recommended Playlists',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'The result for your swipe is here.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        // Sparkle column
        Column(
          children: [
            Icon(Icons.star, color: _pink.withValues(alpha: 0.9), size: 11),
            const SizedBox(height: 5),
            Icon(Icons.star,
                color: Colors.white.withValues(alpha: 0.4), size: 7),
            const SizedBox(height: 5),
            Icon(Icons.star,
                color: _purple.withValues(alpha: 0.8), size: 9),
          ],
        ),
      ],
    );
  }

  Widget _buildGlowCard(PlaylistModel playlist) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _pink.withValues(alpha: 0.45),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: _deepPurple.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PlaylistCard(playlist: playlist, onReturn: onReturn),
    );
  }
}
