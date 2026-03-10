import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/match/models/match_model.dart';
import '../features/users/models/user.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/match_widgets/top_match_card.dart';
import '../widgets/match_widgets/match_list.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<MatchModel> _matches = [];
  Map<String, UserModel> _userProfiles = {};
  UserModel? _currentUser;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void reload() => _loadData();

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final currentUser = await ServiceLocator.userRepository.me();
      final matches = await ServiceLocator.matchRepository
          .getMatchByUserId(currentUser?.userId ?? '');

      // Fetch profiles for all matched users
      final Map<String, UserModel> profiles = {};
      for (final match in matches) {
        final otherUserId = match.userAId == currentUser?.userId
            ? match.userBId
            : match.userAId;
        if (!profiles.containsKey(otherUserId)) {
          final profile =
              await ServiceLocator.userRepository.getProfile(otherUserId);
          if (profile != null) {
            profiles[otherUserId] = profile;
          }
        }
      }

      if (mounted) {
        setState(() {
          _currentUser = currentUser;
          _matches = matches;
          _userProfiles = profiles;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load matches';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: _loading
          ? Center(child: CircularProgressIndicator(color: colors.primary))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!,
                          style: TextStyle(color: colors.onBackground)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                )
              : _matches.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 64, color: colors.onSurface.withAlpha(100)),
                          const SizedBox(height: 16),
                          Text(
                            'No matches yet',
                            style: AppTextStyles.textLg(context).copyWith(
                              color: colors.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start swiping to find your vibe tribe!',
                            style: TextStyle(color: colors.onSurface),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadData,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Vibe Tribe',
                              style: AppTextStyles.textXl(context).copyWith(
                                color: colors.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.search,
                                    color: colors.onSurface, size: 24),
                                const SizedBox(width: 16),
                                Icon(Icons.tune,
                                    color: colors.onSurface, size: 24),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Top Match Hero Card ──
                      if (_matches.isNotEmpty)
                        TopMatchCard(
                          user: _userProfiles[
                              _matches.first.userAId == _currentUser?.userId
                                  ? _matches.first.userBId
                                  : _matches.first.userAId],
                          matchId: _matches.first.matchId,
                          currentUserId: _currentUser?.userId ?? '',
                        ),

                      const SizedBox(height: 24),

                      // ── Your Matches ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Your Matches',
                          style: AppTextStyles.textLg(context).copyWith(
                            color: colors.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      MatchList(
                        matches: _matches,
                        userProfiles: _userProfiles,
                        currentUserId: _currentUser?.userId ?? '',
                      ),
                    ],
                  ),
                ),
    );
  }
}
