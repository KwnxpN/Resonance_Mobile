import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SoundCloudService {
  static const String _baseUrl = 'https://api.soundcloud.com';
  static const String _clientId = '';
  static const String _clientSecret = '';
  // Token storage
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  /// Get a valid access token, refreshing if necessary
  Future<String?> _getAccessToken() async {
    // If we have a valid token, return it
    if (_accessToken != null && _tokenExpiry != null) {
      // Refresh 5 minutes before expiry
      if (DateTime.now().isBefore(
        _tokenExpiry!.subtract(const Duration(minutes: 5)),
      )) {
        return _accessToken;
      }
    }

    // If we have a refresh token, try to refresh
    if (_refreshToken != null) {
      final refreshed = await _refreshAccessToken();
      if (refreshed) return _accessToken;
    }

    // Otherwise, get a new token using client_credentials
    final success = await _fetchNewToken();
    return success ? _accessToken : null;
  }

  /// Fetch a new access token using client_credentials grant
  Future<bool> _fetchNewToken() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/oauth2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode != 200) {
        debugPrint('SoundCloud token fetch failed: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return false;
      }

      final data = json.decode(response.body);
      _accessToken = data['access_token'] as String?;
      _refreshToken = data['refresh_token'] as String?;

      // Token expires in 6 hours (21600 seconds) by default
      final expiresIn = data['expires_in'] as int? ?? 21600;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

      debugPrint(
        'SoundCloud token fetched successfully, expires in $expiresIn seconds',
      );
      return _accessToken != null;
    } catch (e) {
      debugPrint('SoundCloud token fetch error: $e');
      return false;
    }
  }

  /// Refresh the access token using refresh_token grant
  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/oauth2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'grant_type': 'refresh_token',
          'refresh_token': _refreshToken!,
        },
      );

      if (response.statusCode != 200) {
        debugPrint('SoundCloud token refresh failed: ${response.statusCode}');
        // Clear refresh token so we'll get a new one
        _refreshToken = null;
        return false;
      }

      final data = json.decode(response.body);
      _accessToken = data['access_token'] as String?;
      _refreshToken = data['refresh_token'] as String?;

      final expiresIn = data['expires_in'] as int? ?? 21600;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

      debugPrint('SoundCloud token refreshed successfully');
      return _accessToken != null;
    } catch (e) {
      debugPrint('SoundCloud token refresh error: $e');
      _refreshToken = null;
      return false;
    }
  }

  /// Make an authenticated GET request
  Future<http.Response?> _authenticatedGet(String url) async {
    final token = await _getAccessToken();
    if (token == null) {
      debugPrint('Failed to get SoundCloud access token');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'OAuth $token'},
      );
      return response;
    } catch (e) {
      debugPrint('SoundCloud authenticated request error: $e');
      return null;
    }
  }

  /// Search for a track on SoundCloud and return stream URL
  Future<String?> findTrackAudio(String trackName, String artist) async {
    try {
      final query = Uri.encodeComponent('$trackName $artist');
      final url = '$_baseUrl/tracks?q=$query&limit=1';

      debugPrint('SoundCloud search URL: $url');

      final response = await _authenticatedGet(url);

      if (response == null) {
        debugPrint('SoundCloud search failed: null response');
        return null;
      }

      debugPrint('SoundCloud search status: ${response.statusCode}');
      debugPrint(
        'SoundCloud response body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}',
      );

      if (response.statusCode != 200) {
        debugPrint('SoundCloud search failed: ${response.statusCode}');
        return null;
      }

      final data = json.decode(response.body);
      debugPrint('SoundCloud data type: ${data.runtimeType}');

      // API may return data in a "collection" wrapper
      List? tracks;
      if (data is List) {
        tracks = data;
      } else if (data is Map && data['collection'] is List) {
        tracks = data['collection'] as List;
        debugPrint('Using collection wrapper format');
      }

      if (tracks != null && tracks.isNotEmpty) {
        final track = tracks[0] as Map<String, dynamic>;
        debugPrint(
          'SoundCloud track found: ${track['title']} by ${track['user']?['username']}',
        );
        return await _getStreamUrlFromTrack(track);
      }

      debugPrint('SoundCloud search returned no results');
      return null;
    } catch (e, stackTrace) {
      debugPrint('SoundCloud search error: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Get track details by SoundCloud track ID
  Future<Map<String, dynamic>?> getTrack(String trackId) async {
    try {
      final url = '$_baseUrl/tracks/$trackId';

      final response = await _authenticatedGet(url);

      if (response == null || response.statusCode != 200) {
        return null;
      }

      return json.decode(response.body) as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('SoundCloud get track error: $e');
      return null;
    }
  }

  /// Get stream URL for a specific track ID
  Future<String?> getStreamUrl(String trackId) async {
    try {
      final track = await getTrack(trackId);
      if (track == null) return null;

      return await _getStreamUrlFromTrack(track);
    } catch (e) {
      debugPrint('SoundCloud stream URL error: $e');
      return null;
    }
  }

  /// Extract stream URL from track data using media.transcodings
  Future<String?> _getStreamUrlFromTrack(Map<String, dynamic> track) async {
    try {
      // Get the track_authorization - required for accessing stream URLs
      final trackAuthorization = track['track_authorization'] as String?;
      debugPrint(
        'Track authorization: ${trackAuthorization != null ? "present" : "missing"}',
      );

      // Try to get stream URL from media.transcodings (newer API format)
      final media = track['media'] as Map<String, dynamic>?;
      if (media != null) {
        final transcodings = media['transcodings'] as List?;
        debugPrint('Found ${transcodings?.length ?? 0} transcodings');

        if (transcodings != null && transcodings.isNotEmpty) {
          // Find a progressive (direct) stream or HLS stream
          for (final transcoding in transcodings) {
            final format = transcoding['format'] as Map<String, dynamic>?;
            final protocol = format?['protocol'] as String?;
            final mimeType = format?['mime_type'] as String?;
            debugPrint('Transcoding: protocol=$protocol, mime=$mimeType');

            // Prefer progressive streams as they work better with just_audio
            if (protocol == 'progressive') {
              final streamUrl = transcoding['url'] as String?;
              if (streamUrl != null) {
                return await _resolveStreamUrl(streamUrl, trackAuthorization);
              }
            }
          }

          // Fallback to first available transcoding (usually HLS)
          final firstTranscoding = transcodings[0];
          final streamUrl = firstTranscoding['url'] as String?;
          if (streamUrl != null) {
            debugPrint('Using fallback transcoding (HLS)');
            return await _resolveStreamUrl(streamUrl, trackAuthorization);
          }
        }
      }

      // Fallback: Try direct stream_url (older API format)
      // Need to resolve to actual CDN URL for player to access without auth
      final streamUrl = track['stream_url'] as String?;
      if (streamUrl != null) {
        debugPrint('Using legacy stream_url');
        return await _resolveLegacyStreamUrl(streamUrl);
      }

      debugPrint('No stream URL found in track data');
      return null;
    } catch (e) {
      debugPrint('Error extracting stream URL: $e');
      return null;
    }
  }

  /// Resolve the transcoding URL to get the actual stream URL
  Future<String?> _resolveStreamUrl(
    String transcodingUrl,
    String? trackAuthorization,
  ) async {
    try {
      // Build URL with track_authorization parameter
      final uri = Uri.parse(transcodingUrl);
      final params = Map<String, String>.from(uri.queryParameters);
      if (trackAuthorization != null) {
        params['track_authorization'] = trackAuthorization;
      }
      final resolveUrl = uri.replace(queryParameters: params).toString();

      debugPrint('Resolving stream URL: $resolveUrl');

      final response = await _authenticatedGet(resolveUrl);

      if (response == null) {
        debugPrint('Failed to resolve stream URL: null response');
        return null;
      }

      debugPrint('Resolve response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('Failed to resolve stream URL: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }

      // Check if response is JSON or direct audio stream
      final contentType = response.headers['content-type'] ?? '';

      // If the response is audio, the URL is directly streamable
      if (contentType.contains('audio/')) {
        debugPrint('Response is direct audio stream ($contentType)');
        debugPrint('Using URL directly: $resolveUrl');
        return resolveUrl;
      }

      if (!contentType.contains('application/json')) {
        debugPrint('Unexpected content type: $contentType');
        debugPrint(
          'Response body (first 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
        );
        return null;
      }

      final data = json.decode(response.body);
      final url = data['url'] as String?;
      debugPrint(
        'Resolved stream URL: ${url != null ? "success" : "missing url field"}',
      );
      return url;
    } catch (e) {
      debugPrint('Error resolving stream URL: $e');
      return null;
    }
  }

  /// Resolve legacy stream_url to get actual CDN URL
  /// The legacy stream_url requires auth, so we make an authenticated request
  /// and extract the redirect URL that the player can access without auth
  Future<String?> _resolveLegacyStreamUrl(String streamUrl) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        debugPrint('No access token for legacy stream resolution');
        return null;
      }

      debugPrint('Resolving legacy stream URL: $streamUrl');

      // Use http client that doesn't follow redirects to capture the redirect URL
      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(streamUrl));
        request.headers['Authorization'] = 'OAuth $token';
        request.followRedirects = false;

        final streamedResponse = await client.send(request);

        debugPrint(
          'Legacy stream response status: ${streamedResponse.statusCode}',
        );
        debugPrint(
          'Legacy stream response headers: ${streamedResponse.headers}',
        );

        // Check for redirect (302, 301, 303, 307, 308)
        if (streamedResponse.statusCode >= 300 &&
            streamedResponse.statusCode < 400) {
          final location = streamedResponse.headers['location'];
          if (location != null) {
            debugPrint('Got CDN redirect URL: $location');
            return location;
          }
        }

        // If 200, the URL itself might be streamable (unlikely with legacy)
        if (streamedResponse.statusCode == 200) {
          // Check content type
          final contentType = streamedResponse.headers['content-type'] ?? '';
          if (contentType.contains('audio/')) {
            debugPrint('Legacy URL is directly streamable (audio content)');
            // Unfortunately we can't use this URL directly as it requires auth
            // Try to get the actual CDN URL from response headers
            return null;
          }

          // Try to parse as JSON for the URL
          final body = await streamedResponse.stream.bytesToString();
          try {
            final data = json.decode(body);
            if (data is Map && data['url'] != null) {
              final cdnUrl = data['url'] as String;
              debugPrint('Got CDN URL from JSON response: $cdnUrl');
              return cdnUrl;
            }
          } catch (_) {
            // Not JSON
          }
        }

        debugPrint(
          'Failed to resolve legacy stream URL: ${streamedResponse.statusCode}',
        );
        return null;
      } finally {
        client.close();
      }
    } catch (e) {
      debugPrint('Error resolving legacy stream URL: $e');
      return null;
    }
  }
}
