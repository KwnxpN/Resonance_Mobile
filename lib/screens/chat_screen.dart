import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  final String userImage;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(context, colors),
      body: Column(
        children: [
          // Chat messages
          Expanded(child: _buildChatBody(context, colors)),

          // Message input
          _buildMessageInput(context, colors),
        ],
      ),
    );
  }

  // ─────────────────── App Bar ───────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context, AppColors colors) {
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colors.onBackground),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary, width: 2),
              image: DecorationImage(
                image: NetworkImage(userImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: AppTextStyles.textMd(context).copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.headphones, color: colors.primary, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'Listening to Daft Punk',
                    style: AppTextStyles.textXs(
                      context,
                    ).copyWith(color: colors.muted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: colors.onBackground),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─────────────────── Chat Body ───────────────────
  Widget _buildChatBody(BuildContext context, AppColors colors) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // System message
        _buildSystemMessage(
          context,
          colors,
          '🎵 You matched! You both like Tame Impala.',
        ),
        const SizedBox(height: 16),

        // Incoming message
        _buildIncomingMessage(context, colors, 'Hey! Nice taste in music. 👋'),
        const SizedBox(height: 12),

        // Outgoing message
        _buildOutgoingMessage(
          context,
          colors,
          'Thanks! Have you heard their new single?',
        ),
        const SizedBox(height: 12),

        // Incoming message with song card
        _buildIncomingMessage(context, colors, 'Yeah, check this out:'),
        const SizedBox(height: 8),
        _buildSongCard(context, colors),
        const SizedBox(height: 16),

        // Typing indicator
        _buildTypingIndicator(context, colors),
      ],
    );
  }

  Widget _buildSystemMessage(
    BuildContext context,
    AppColors colors,
    String text,
  ) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: AppTextStyles.textXs(context).copyWith(color: colors.muted),
        ),
      ),
    );
  }

  Widget _buildIncomingMessage(
    BuildContext context,
    AppColors colors,
    String text,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Small avatar
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(userImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: AppTextStyles.textSm(
                context,
              ).copyWith(color: colors.onSurface),
            ),
          ),
        ),
        const SizedBox(width: 60), // right spacing
      ],
    );
  }

  Widget _buildOutgoingMessage(
    BuildContext context,
    AppColors colors,
    String text,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 60), // left spacing
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              text,
              style: AppTextStyles.textSm(
                context,
              ).copyWith(color: colors.onPrimary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSongCard(BuildContext context, AppColors colors) {
    return Row(
      children: [
        const SizedBox(width: 36), // align with messages
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border, width: 0.8),
            ),
            child: Row(
              children: [
                // Album art placeholder
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colors.accent,
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1514924013411-cbf25faa35bb?w=100&h=100&fit=crop',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Less I Know The Better',
                        style: AppTextStyles.textSm(context).copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Tame Impala',
                        style: AppTextStyles.textXs(
                          context,
                        ).copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.favorite, color: colors.primary, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(width: 60),
      ],
    );
  }

  Widget _buildTypingIndicator(BuildContext context, AppColors colors) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(userImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dot(colors, 0.4),
              const SizedBox(width: 4),
              _dot(colors, 0.6),
              const SizedBox(width: 4),
              _dot(colors, 0.9),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dot(AppColors colors, double opacity) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  // ─────────────────── Message Input ───────────────────
  Widget _buildMessageInput(BuildContext context, AppColors colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border, width: 0.8)),
      ),
      child: Row(
        children: [
          // Mic icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.music_note, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 8),

          // Text field
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Message...',
                style: AppTextStyles.textSm(
                  context,
                ).copyWith(color: colors.muted),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Mic button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.mic, color: colors.muted, size: 20),
          ),
          const SizedBox(width: 8),

          // Send button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.send, color: colors.onPrimary, size: 18),
          ),
        ],
      ),
    );
  }
}
