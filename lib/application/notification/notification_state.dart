part of 'notification_bloc.dart';

abstract class _CommonBaseState {
  AppNotificationType get type;

  List<NotificationItemImage> get images;

  bool get showNotification;

  String get note;

  String get title;

  String get body;

  bool get isTitleValid;

  bool get isTitleDirty;

  bool get isBodyValid;

  bool get isBodyDirty;

  bool get isNoteValid;

  bool get isNoteDirty;

  bool get showOtherImages;
}

@freezed
class NotificationState with _$NotificationState {
  @Implements<_CommonBaseState>()
  const factory NotificationState.custom({
    int? key,
    @Default(<NotificationItemImage>[]) List<NotificationItemImage> images,
    @Default(AppNotificationType.custom) AppNotificationType type,
    @Default(true) bool showNotification,
    required AppNotificationItemType itemType,
    @Default('') String title,
    @Default('') String body,
    @Default(false) bool isTitleValid,
    @Default(false) bool isTitleDirty,
    @Default(false) bool isBodyValid,
    @Default(false) bool isBodyDirty,
    @Default(true) bool isNoteValid,
    @Default(false) bool isNoteDirty,
    @Default('') String note,
    @Default(false) bool showOtherImages,
    required DateTime scheduledDate,
    required LanguageModel language,
    @Default(false) bool useTwentyFourHoursFormat,
  }) = _CustomState;

  @Implements<_CommonBaseState>()
  const factory NotificationState.dailyCheckIn({
    int? key,
    @Default(<NotificationItemImage>[]) List<NotificationItemImage> images,
    @Default(AppNotificationType.dailyCheckIn) AppNotificationType type,
    @Default(true) bool showNotification,
    @Default('') String title,
    @Default('') String body,
    @Default(false) bool isTitleValid,
    @Default(false) bool isTitleDirty,
    @Default(false) bool isBodyValid,
    @Default(false) bool isBodyDirty,
    @Default(true) bool isNoteValid,
    @Default(false) bool isNoteDirty,
    @Default('') String note,
    @Default(false) bool showOtherImages,
  }) = _DailyCheckInState;
}