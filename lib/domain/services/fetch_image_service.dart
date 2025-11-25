import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:aurora/domain/endpoints/fetch_image_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final fetchImageServiceProvider = Provider<FetchImageService>((ref) {
  return FetchImageService();
});

class FetchImageService {
  final _cache = <String, Uint8List>{};

  Future<(Uint8List response, String? error)> fetchImage() async {
    try {
      final response = await http.get(Uri.parse(FetchImageEndpoints.fetch));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final url = data["url"] as String?;

        if (url == null || url.isEmpty) {
          return (Uint8List(0), "Error fetching image url");
        }

        if (_cache.containsKey(url)) {
          return (_cache[url]!, null);
        }

        final bytes = await http.get(Uri.parse(url));
        if (bytes.statusCode != 200) {
          return (Uint8List(0), "Error downloading image");
        }

        _cache[url] = bytes.bodyBytes;

        return (bytes.bodyBytes, null);
      } else {
        return (Uint8List(0), "Error fetching image");
      }
    } catch (e) {
      log("Error fetching image: $e");
      return (Uint8List(0), "Error fetching image");
    }
  }
}
