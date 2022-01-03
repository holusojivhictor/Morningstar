part of 'preload_bloc.dart';

@freezed
class PreloadState with _$PreloadState {
  const factory PreloadState({
    required List<String> videoSources,
    required Map<int, VideoPlayerController> controllers,
    required int focusedIndex,
  }) = _PreloadState;

  factory PreloadState.initial({required VideoPlayerController controller}) => PreloadState(
    focusedIndex: 0,
    videoSources: [
      'assets/videos/home-playback.mp4',
    ],
    controllers: {0: controller},
  );
}