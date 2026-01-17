import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/swipe_card.dart';
import '../widgets/discover_app_bar.dart';
import '../services/track_api.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({super.key});
  
  
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
  
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Future<List<Track>> futureTracks;

  @override
  void initState() {
    super.initState();
    futureTracks = TrackApi.getRandomTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120914),
      body: SafeArea(
        child: Column(
          children: [
            const DiscoverAppBar(),
            Expanded(
              child: FutureBuilder<List<Track>>(
                future: futureTracks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style:
                            const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final tracks = snapshot.data!;

                  return PageView.builder(
                    controller:
                        PageController(viewportFraction: 0.9),
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      return SwipeCard(track: tracks[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

