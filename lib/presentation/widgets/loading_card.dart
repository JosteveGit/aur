import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingCard extends StatelessWidget {
  final double side;
  const LoadingCard(this.side, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: side,
            height: side,
            color: Colors.grey.shade800,
          ),
        )
        .animate(key: const ValueKey('loading_card'))
        .shimmer(color: Colors.grey.shade300, duration: 2.seconds);
  }
}
