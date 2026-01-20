import 'dart:convert';
import 'package:http/http.dart' as http;

class JamendoService {
  static const String _baseUrl = 'https://api.jamendo.com/v3.0';
  static const String _clientId =
      'efb6d48a'; // ← Replace this

  /// Search for a track on Jamendo
  Future<String?> findTrackAudio(String trackName, String artist) async {
    try {
      final query = Uri.encodeComponent('$trackName $artist');
      final url = Uri.parse(
        '$_baseUrl/tracks/?'
        'client_id=$_clientId&'
        'format=json&'
        'limit=1&'
        'search=$query&'
        'audioformat=mp32',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final data = json.decode(response.body);
      final results = data['results'] as List?;

      if (results != null && results.isNotEmpty) {
        return results[0]['audio'] as String?;
      }

      return null;
    } catch (e) {
      print('Jamendo search error: $e');
      return null;
    }
  }

  /// Get direct audio URL by Jamendo track ID
  Future<String?> getAudioUrl(String jamendoId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/tracks/?'
        'client_id=$_clientId&'
        'format=json&'
        'id=$jamendoId&'
        'audioformat=mp32',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final data = json.decode(response.body);
      final results = data['results'] as List?;

      if (results != null && results.isNotEmpty) {
        return results[0]['audio'] as String?;
      }

      return null;
    } catch (e) {
      print('Jamendo audio URL error: $e');
      return null;
    }
  }
}