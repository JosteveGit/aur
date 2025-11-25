import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<(Uint8List, Color)> generateColor(Uint8List bytes) async {
  final (newBytes, rgb) = await compute(_dominantColorFromBytes, bytes);
  return (newBytes, Color.fromARGB(255, rgb[0], rgb[1], rgb[2]));
}

(Uint8List, List<int>) _dominantColorFromBytes(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return (Uint8List(0), [32, 32, 32]);

  final image = img.copyResize(decoded, width: 1024);

  final newBytes = Uint8List.fromList(img.encodePng(image));

  num rTotal = 0, gTotal = 0, bTotal = 0, count = 0;

  final totalPixels = image.width * image.height;

  final step = totalPixels > 8000 ? totalPixels ~/ 8000 : 1;

  for (int i = 0; i < totalPixels; i += step) {
    final x = i % image.width;
    final y = i ~/ image.width;

    final pixel = image.getPixel(x, y);
    rTotal += pixel.r;
    gTotal += pixel.g;
    bTotal += pixel.b;
    count++;
  }

  final r = (rTotal / count).round().clamp(0, 255);
  final g = (gTotal / count).round().clamp(0, 255);
  final b = (bTotal / count).round().clamp(0, 255);

  return (newBytes, [r, g, b]);
}
