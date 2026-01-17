import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track.dart';

class TrackApi {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<List<Track>> getRandomTracks() async {
    final response =
        await http.get(Uri.parse('$baseUrl/tracks/random'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Track.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }
}
