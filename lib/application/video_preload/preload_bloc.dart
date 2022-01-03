import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_player/video_player.dart';

part 'preload_bloc.freezed.dart';
part 'preload_event.dart';
part 'preload_state.dart';

class PreloadBloc extends Bloc<PreloadEvent, PreloadState> {
  static get controller => VideoPlayerController.asset('');

  PreloadBloc() : super(PreloadState.initial(controller: controller));

  @override
  Stream<PreloadState> mapEventToState(PreloadEvent event) async* {
    final Stream<PreloadState> s = event.map(
      initialize: (e) async* {
         await _initializeControllerAtIndex(0);
        _playControllerAtIndex(0);
      },
      dispose: (e) async* {
        _disposeControllerAtIndex(0);
      },
    );

    yield* s;
  }

  Future _initializeControllerAtIndex(int index) async {
    if (state.videoSources.length > index && index >= 0) {
      final VideoPlayerController _controller = VideoPlayerController.asset(state.videoSources[index]);
      state.controllers[index] = _controller;

      await _controller.initialize();
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.videoSources.length > index && index >= 0) {
      final VideoPlayerController _controller = state.controllers[index]!;
      _controller.play();
      _controller.setLooping(true);
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.videoSources.length > index && index >= 0) {
      final VideoPlayerController _controller = state.controllers[index]!;

      _controller.pause();

      _controller.seekTo(const Duration());
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.videoSources.length > index && index >= 0) {
      final VideoPlayerController _controller = state.controllers[index]!;
      _controller.dispose();

      state.controllers.remove(_controller);
    }
  }
}