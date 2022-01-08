import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preload_bloc.freezed.dart';
part 'preload_event.dart';
part 'preload_state.dart';

class PreloadBloc extends Bloc<PreloadEvent, PreloadState> {

  PreloadBloc() : super(const PreloadState.loading());

  @override
  Stream<PreloadState> mapEventToState(PreloadEvent event) async* {
    final s = event.map(
      initialize: (e) => _buildInitialState(),
    );

    yield s;
  }

  PreloadState _buildInitialState() {
    return const PreloadState.loaded(assetName: 'assets/gif/home-playback.gif');
  }
}