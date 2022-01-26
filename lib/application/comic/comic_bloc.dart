import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/application/common/pop_bloc.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'comic_bloc.freezed.dart';
part 'comic_event.dart';
part 'comic_state.dart';

class ComicBloc extends PopBloc<ComicEvent, ComicState> {
  final MorningStarService _morningStarService;
  final TelemetryService _telemetryService;

  ComicBloc(this._morningStarService, this._telemetryService) : super(const ComicState.loading());

  @override
  ComicEvent getEventForPop(String? key) => ComicEvent.loadFromKey(key: key!, addToQueue: false);

  @override
  Stream<ComicState> mapEventToState(ComicEvent event) async* {
    final s = await event.when(
      loadFromKey: (key, addToQueue) async {
        final comic = _morningStarService.getComic(key);

        if (addToQueue) {
          await _telemetryService.trackComicLoaded(key);
          currentItemsInStack.add(comic.name);
        }
        return _buildInitialState(comic);
      },
    );

    yield s;
  }

  ComicState _buildInitialState(ComicFileModel comic) {
    return ComicState.loaded(
      name: comic.name,
      season: comic.season,
      cover: comic.imagePath,
      pages: comic.pages.map((page) {
        return ComicPageCardModel(
          number: page.number,
          image: page.imagePath,
          season: page.season,
        );
      }).toList(),
    );
  }
}