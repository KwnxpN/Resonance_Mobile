import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class MusicPlayerCard extends StatelessWidget {
  const MusicPlayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(16), // Outer padding
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text (kept from your code)
          Text(
            'My Anthem',
            style: AppTextStyles.textLg(context).copyWith(
              color: colors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // The Player Card
          Container(
            padding: const EdgeInsets.all(8), // Inner padding for the card
            decoration: BoxDecoration(
              color: const Color(0xFF3A1C2E), // Dark Plum/Brown background
              borderRadius: BorderRadius.circular(50), // Pill shape
            ),
            child: Row(
              children: [
                // 1. Album Art
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    40,
                  ), // Circular/Rounded Image
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/en/4/46/M83_-_Midnight_City.jpg', // Placeholder for "Midnight City" art
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 55,
                      height: 55,
                      color: Colors.black26,
                      child: const Icon(Icons.music_note, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // 2. Text Info & Progress Bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Song Title
                      const Text(
                        'Midnight City',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Artist & Album
                      Text(
                        "M83 • Hurry Up, We're Dreaming",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      // Custom Progress Bar
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              // Background Line
                              Container(
                                height: 4,
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              // Active Pink Line (Approx 60% progress)
                              Container(
                                height: 4,
                                width: constraints.maxWidth * 0.6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF0080), // Hot Pink
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // 3. Play Button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0080), // Hot Pink
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF0080).withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
