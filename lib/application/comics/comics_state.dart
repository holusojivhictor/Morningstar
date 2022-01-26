part of 'comics_bloc.dart';

@freezed
class ComicsState with _$ComicsState {
  const factory ComicsState.loading() = _LoadingState;

  const factory ComicsState.loaded({
    required List<ComicCardModel> comics,
  }) = _LoadedState;
}