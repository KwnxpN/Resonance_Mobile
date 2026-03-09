import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/playlists/models/playlist.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class AddToPlaylistSheet extends StatefulWidget {
  final List<PersonalPlaylistModel> playlists;
  final String trackId;

  const AddToPlaylistSheet({
    super.key,
    required this.playlists,
    required this.trackId,
  });

  @override
  State<AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  String? _loadingId;

  void _showToast(BuildContext context, {required bool success}) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _ToastOverlay(
        success: success,
        colors: colors,
        onDone: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  Future<void> _addTo(String playlistId) async {
    setState(() => _loadingId = playlistId);
    final success = await ServiceLocator.playlistRepository
        .addTrackToPlaylist(playlistId, widget.trackId);
    if (!mounted) return;
    Navigator.pop(context);
    _showToast(context, success: success);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle + title (non-scrollable)
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add to playlist',
                  style: AppTextStyles.textLg(context).copyWith(
                    color: colors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Scrollable list
            Expanded(
              child: widget.playlists.isEmpty
                  ? Center(
                      child: Text(
                        'No playlists found',
                        style: AppTextStyles.textMd(context)
                            .copyWith(color: colors.muted),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: widget.playlists.length,
                      itemBuilder: (_, i) {
                        final playlist = widget.playlists[i];
                        final isLoading = _loadingId == playlist.id;
                        return ListTile(
                          leading:
                              Icon(Icons.queue_music, color: colors.primary),
                          title: Text(
                            playlist.name,
                            style: AppTextStyles.textMd(context)
                                .copyWith(color: colors.onBackground),
                          ),
                          subtitle: Text(
                            '${playlist.tracks.length} tracks',
                            style: AppTextStyles.textSm(context)
                                .copyWith(color: colors.muted),
                          ),
                          trailing: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.primary,
                                  ),
                                )
                              : null,
                          onTap: isLoading ? null : () => _addTo(playlist.id),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _ToastOverlay extends StatefulWidget {
  final bool success;
  final AppColors colors;
  final VoidCallback onDone;

  const _ToastOverlay({
    required this.success,
    required this.colors,
    required this.onDone,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) await _controller.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Positioned(
      bottom: 48,
      left: 24,
      right: 24,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _slide,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: widget.success ? colors.primary : Colors.red.shade800,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (widget.success ? colors.primary : Colors.red)
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    widget.success
                        ? Icons.check_circle_rounded
                        : Icons.error_rounded,
                    color: colors.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.success
                        ? 'Added to playlist'
                        : 'Failed to add track',
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
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
