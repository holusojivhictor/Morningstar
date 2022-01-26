part of 'comic_bloc.dart';

@freezed
class ComicState with _$ComicState {
  const factory ComicState.loading() = _LoadingState;

  const factory ComicState.loaded({
    required String name,
    required ComicSeasonType season,
    required String cover,
    required List<ComicPageCardModel> pages,
  }) = _LoadedState;
}