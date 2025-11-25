import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ImageCard extends StatelessWidget {
  final double side;
  final Uint8List bytes;
  const ImageCard(this.side, this.bytes, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: side,
            height: side,
            child: Image.memory(bytes, fit: BoxFit.cover),
          ),
        )
        .animate(key: ValueKey(bytes.hashCode))
        .shimmer(delay: 100.ms, duration: 2.seconds)
        .shake(hz: 4)
        .scaleXY(end: 1.1, duration: 600.ms)
        .then(delay: 600.ms)
        .scaleXY(end: (1 / 1.1));
  }
}
