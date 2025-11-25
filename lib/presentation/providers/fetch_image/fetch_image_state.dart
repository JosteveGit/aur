import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract interface class FetchImageState {
  const FetchImageState();

  bool get isLoading => this is FetchImageLoading;
  bool get isLoaded => this is FetchImageLoaded;
  bool get isError => this is FetchImageError;

  (Uint8List imageBytes, Color color)? get data {
    if (this is FetchImageLoaded) {
      final state = this as FetchImageLoaded;
      return (state.imageBytes, state.color);
    }
    return null;
  }

  String? get errorMessage {
    if (this is FetchImageError) {
      final state = this as FetchImageError;
      return state.message;
    }
    return null;
  }
}

final class FetchImageLoading extends FetchImageState {
  const FetchImageLoading();
}

final class FetchImageLoaded extends FetchImageState {
  final Uint8List imageBytes;
  final Color color;

  const FetchImageLoaded(this.imageBytes, this.color);
}

final class FetchImageError extends FetchImageState {
  final String message;

  const FetchImageError(this.message);
}
