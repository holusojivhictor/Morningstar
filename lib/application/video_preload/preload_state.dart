part of 'preload_bloc.dart';

@freezed
class PreloadState with _$PreloadState {
  const factory PreloadState.loading() = _LoadingState;

  const factory PreloadState.loaded({
    required String assetName,
  }) = _LoadedState;
}