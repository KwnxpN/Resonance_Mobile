import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../widgets/home_widgets/track_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future for fetching tracks from API
  late Future<List<TrackModel>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _tracksFuture = ServiceLocator.musicRepository.getRandomTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TrackModel>>(
        future: _tracksFuture,
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

          final tracks = snapshot.data!;
          // Paginated 3x3 grids (9 items per page) using a PageView
          final pageSize = 9;
          final pageCount = (tracks.length / pageSize).ceil();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: PageView.builder(
                  itemCount: pageCount,
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * pageSize;
                    final endIndex = (startIndex + pageSize).clamp(0, tracks.length);
                    final pageItems = tracks.sublist(startIndex, endIndex);

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: pageItems.length,
                      itemBuilder: (context, index) {
                        return TrackCard(track: pageItems[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
