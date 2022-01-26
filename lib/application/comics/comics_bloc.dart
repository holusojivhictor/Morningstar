import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';

part 'comics_bloc.freezed.dart';
part 'comics_event.dart';
part 'comics_state.dart';

class ComicsBloc extends Bloc<ComicsEvent, ComicsState> {
  final MorningStarService _morningStarService;

  ComicsBloc(this._morningStarService) : super(const ComicsState.loading());

  _LoadedState get currentState => state as _LoadedState;

  @override
  Stream<ComicsState> mapEventToState(ComicsEvent event) async* {
    final s = event.map(
      init: (e) => _buildInitialState(),
    );

    yield s;
  }

  ComicsState _buildInitialState() {
    final isLoaded = state is _LoadedState;
    var data = _morningStarService.getComicsForCard();

    if (!isLoaded) {
      return ComicsState.loaded(comics: data);
    }

    final s = currentState.copyWith.call(
      comics: data,
    );

    return s;
  }
}