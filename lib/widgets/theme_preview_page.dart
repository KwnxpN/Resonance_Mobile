import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_gradients.dart';
import '../themes/app_text_styles.dart';
import '../screens/music_playback_screen.dart';

class ThemePreviewPage extends StatelessWidget {
  const ThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC2QC8Wz7IX96K0iDdGouOsx-7HvVoht5QG2p7PX3FVFo7XLvZsJCfqYMhI0xRM1XX2NNEoM_4EmpQOSBnITLKbn6Dp6N31vqFDP_DS6a3q9mytsJUQZXICfuYlfj4QQjypr4fQN8JbfgfOnlxXlQ3WaP2IwgSxIllLTdpHcpJHsyNaIoSVbMIvHu5c0l7Ux3Yd1ihOgeyQGQ6oZW0HTvSOlIvUGEm7XpAR3-cBy0ykqtbj7wVrJBaE5I9xrpSwaXsD4yj2Tu6fV3-Q',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppGradients.authOverlay(context),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'Text Styles'),
                  _textSamples(context),

                  const SizedBox(height: 32),

                  _sectionTitle(context, 'Primary & Surface'),
                  _primaryButtons(context),

                  const SizedBox(height: 32),

                  _sectionTitle(context, 'Status Colors'),
                  _statusChips(context),

                  const SizedBox(height: 32),

                  _sectionTitle(context, 'Surface & Border'),
                  _surfaceCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------
  // Sections
  // -----------------------

  Widget _sectionTitle(BuildContext context, String title) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Text(
      title,
      style: AppTextStyles.textLg(context).copyWith(color: colors.onBackground),
    );
  }

  Widget _textSamples(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text 4XL',
          style: AppTextStyles.text4xl(
            context,
          ).copyWith(color: colors.onBackground),
        ),
        Text(
          'Text 3XL',
          style: AppTextStyles.text3xl(
            context,
          ).copyWith(color: colors.onBackground),
        ),
        Text(
          'Text 2XL',
          style: AppTextStyles.text2xl(
            context,
          ).copyWith(color: colors.onBackground),
        ),
        Text(
          'Text XL',
          style: AppTextStyles.textXl(
            context,
          ).copyWith(color: colors.onBackground),
        ),
        Text(
          'Text LG',
          style: AppTextStyles.textLg(
            context,
          ).copyWith(color: colors.onBackground),
        ),
        Text(
          'Text MD',
          style: AppTextStyles.textMd(context).copyWith(color: colors.muted),
        ),
        Text(
          'Text SM',
          style: AppTextStyles.textSm(context).copyWith(color: colors.muted),
        ),
        Text(
          'Text XS',
          style: AppTextStyles.textXs(context).copyWith(color: colors.muted),
        ),
      ],
    );
  }

  Widget _primaryButtons(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.primaryVariant],
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const MusicPlaybackScreen(
                    tracks: [], // Demo only
                    initialIndex: 0,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Primary Gradient Button',
              style: AppTextStyles.textMd(
                context,
              ).copyWith(color: colors.onPrimary),
            ),
          ),
        ),

        const SizedBox(height: 12),

        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colors.border),
          ),
          child: Text(
            'Secondary Button',
            style: AppTextStyles.textMd(
              context,
            ).copyWith(color: colors.onBackground),
          ),
        ),
      ],
    );
  }

  Widget _statusChips(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _chip('Success', colors.success, colors.onSuccess),
        _chip('Warning', colors.warning, colors.onWarning),
        _chip('Error', colors.error, colors.onError),
        _chip('Info', colors.info, colors.onInfo),
      ],
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _surfaceCard(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        'This is a surface card using surface + border + muted text.',
        style: AppTextStyles.textMd(context).copyWith(color: colors.muted),
      ),
    );
  }
}
