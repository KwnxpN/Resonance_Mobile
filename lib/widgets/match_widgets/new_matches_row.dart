import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class NewMatchesRow extends StatelessWidget {
  const NewMatchesRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    final matches = [
      {'name': 'Discovery', 'icon': true},
      {
        'name': 'Sarah',
        'image':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'Marcus',
        'image':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'Chloe',
        'image':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'David',
        'image':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: matches.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final match = matches[index];
          final isDiscovery = match['icon'] == true;

          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isDiscovery
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colors.primary, colors.accent],
                        ),
                  color: isDiscovery
                      ? colors.primary.withValues(alpha: 0.2)
                      : null,
                ),
                child: isDiscovery
                    ? Icon(Icons.bolt, color: colors.primary, size: 28)
                    : Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(match['image'] as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                match['name'] as String,
                style: AppTextStyles.textXs(
                  context,
                ).copyWith(color: colors.onSurface.withValues(alpha: 0.8)),
              ),
            ],
          );
        },
      ),
    );
  }
}
