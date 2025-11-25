import 'package:aurora/domain/services/fetch_image_service.dart';
import 'package:aurora/functions/color_generator.dart';
import 'package:aurora/presentation/providers/fetch_image/fetch_image_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchImageProvider =
    NotifierProvider<FetchImageProvider, FetchImageState>(
      FetchImageProvider.new,
    );

class FetchImageProvider extends Notifier<FetchImageState> {
  late final FetchImageService service;

  @override
  FetchImageState build() {
    service = ref.read(fetchImageServiceProvider);
    return const FetchImageLoading();
  }

  Future<void> fetchImage() async {
    state = const FetchImageLoading();
    final (bytes, error) = await service.fetchImage();
    if (error != null) {
      state = FetchImageError(error);
    } else {
      final (newBytes, palette) = await generateColor(bytes);
      state = FetchImageLoaded(newBytes, palette);
    }
  }
}
