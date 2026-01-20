/// Mock data models for static design

class Song {
  final String id;
  final String title;
  final String artist;
  final String? albumArt;
  final String duration;
  final bool isPlaying;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    this.albumArt,
    required this.duration,
    this.isPlaying = false,
  });
}

class Playlist {
  final String id;
  final String title;
  final String description;
  final String? coverImage;
  final int likesCount;
  final String totalDuration;
  final String tag;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.title,
    required this.description,
    this.coverImage,
    required this.likesCount,
    required this.totalDuration,
    required this.tag,
    required this.songs,
  });
}

/// Mock playlist data
final mockPlaylist = Playlist(
  id: '1',
  title: 'Midnight Vibes',
  description:
      'A selection of the finest synthwave and neon-drenched beats for your late night...',
  coverImage: null,
  likesCount: 12400,
  totalDuration: '2h 15m',
  tag: 'CURATED PLAYLIST',
  songs: mockSongs,
);

/// Mock songs data
final List<Song> mockSongs = [
  const Song(
    id: '1',
    title: 'Neon Cathedral',
    artist: 'Cyber Dreamer • Hyperdrive',
    duration: '4:12',
    isPlaying: false,
  ),
  const Song(
    id: '2',
    title: 'Electric Sky',
    artist: 'The Synth Collective',
    duration: '3:45',
    isPlaying: true,
  ),
  const Song(
    id: '3',
    title: 'After Hours',
    artist: 'Glitch Heart',
    duration: '5:01',
    isPlaying: false,
  ),
  const Song(
    id: '4',
    title: 'Retro Future',
    artist: 'Binary Star',
    duration: '3:18',
    isPlaying: false,
  ),
  const Song(
    id: '5',
    title: 'Static Echoes',
    artist: 'The Signal',
    duration: '4:44',
    isPlaying: false,
  ),
];
