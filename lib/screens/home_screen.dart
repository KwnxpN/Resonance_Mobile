import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../widgets/home_widgets/track_image_card.dart';
import '../widgets/song_card.dart';
import './music_playback_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future for fetching tracks from API
  late Future<List<TrackModel>> _recommendedTracksFuture;
  late Future<List<TrackModel>> _trendingTracksFuture;

  @override
  void initState() {
    super.initState();
    _recommendedTracksFuture = ServiceLocator.musicRepository.getTracks();
    _trendingTracksFuture = ServiceLocator.musicRepository.getTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<List<TrackModel>>>(
        future: Future.wait([_recommendedTracksFuture, _trendingTracksFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tracks available'));
          }

          final recommendedTracks = snapshot.data![0];
          final trendingTracks = snapshot.data![1];
          
          // Paginated 3x3 grids (9 items per page) using a PageView
          final pageSize = 9;
          final pageCount = (recommendedTracks.length / pageSize).ceil();
          
          // Carousel section - 3 songs per page
          final carouselPageSize = 3;
          final carouselPageCount = (trendingTracks.length / carouselPageSize).ceil();
          
          return ListView(
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recommend for you',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  itemCount: pageCount,
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * pageSize;
                    final endIndex = (startIndex + pageSize).clamp(0, recommendedTracks.length);
                    final pageItems = recommendedTracks.sublist(startIndex, endIndex);

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1 / 1,
                      ),
                      itemCount: pageItems.length,
                      itemBuilder: (context, index) {
                        final globalIndex = pageIndex * pageSize + index;
                        return TrackImageCard(
                          track: pageItems[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicPlaybackScreen(
                                  tracks: recommendedTracks,
                                  initialIndex: globalIndex,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Trending Now',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 240,
                child: PageView.builder(
                  itemCount: carouselPageCount,
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * carouselPageSize;
                    final endIndex = (startIndex + carouselPageSize).clamp(0, trendingTracks.length);
                    final pageItems = trendingTracks.sublist(startIndex, endIndex);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: pageItems.asMap().entries.map((entry) {
                          final localIndex = entry.key;
                          final track = entry.value;
                          final globalIndex = pageIndex * carouselPageSize + localIndex;
                          return SongCard(
                            track: track,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicPlaybackScreen(
                                    tracks: trendingTracks,
                                    initialIndex: globalIndex,
                                  ),
                                ),
                              );
                            },
                            onMoreTap: () {
                              print('More options for: ${track.name}');
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
