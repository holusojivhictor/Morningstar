part of 'comic_bloc.dart';

@freezed
class ComicEvent with _$ComicEvent {
  const factory ComicEvent.loadFromKey({
    required String key,
    @Default(true) bool addToQueue,
  }) = _LoadComicFromName;
}