import 'dart:math';

import 'package:aurora/presentation/providers/fetch_image/fetch_image_provider.dart';
import 'package:aurora/presentation/providers/fetch_image/fetch_image_state.dart';
import 'package:aurora/presentation/widgets/error_card.dart';
import 'package:aurora/presentation/widgets/image_card.dart';
import 'package:aurora/presentation/widgets/loading_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RandomImagePage extends ConsumerStatefulWidget {
  const RandomImagePage({super.key});

  @override
  ConsumerState<RandomImagePage> createState() => _RandomImagePageState();
}

class _RandomImagePageState extends ConsumerState<RandomImagePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => fetchNewImage());
  }

  void fetchNewImage() => ref.read(fetchImageProvider.notifier).fetchImage();

  @override
  Widget build(BuildContext context) {
    final fetchImageState = ref.watch(fetchImageProvider);

    ref.listen(fetchImageProvider, (_, next) {
      if (next.isError) HapticFeedback.mediumImpact();
    });

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      color: fetchImageState.data?.$2.withValues(alpha: .8) ?? Colors.black,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                var side = min(constraints.maxWidth, constraints.maxHeight);
                side *= 0.8;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildContent(fetchImageState, side),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: side,
                      height: 48,
                      child: Semantics(
                        button: true,
                        label: 'Load another image',
                        child: ElevatedButton(
                          onPressed: fetchNewImage,
                          child: const Text('Another'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(FetchImageState state, double side) {
    if (state.isLoading) return LoadingCard(side);
    if (state.isError) return ErrorCard(side, state.errorMessage!);
    return ImageCard(side, state.data!.$1);
  }
}
