part of 'notification_bloc.dart';

@freezed
class NotificationEvent with _$NotificationEvent {
  // Common
  const factory NotificationEvent.add({
    required String defaultTitle,
    required String defaultBody,
  }) = _Add;

  const factory NotificationEvent.edit({
    required int key,
    required AppNotificationType type,
  }) = _Edit;

  const factory NotificationEvent.typeChanged({
    required AppNotificationType newValue,
  }) = _TypeChanged;

  const factory NotificationEvent.titleChanged({
    required String newValue,
  }) = _TitleChanged;

  const factory NotificationEvent.bodyChanged({
    required String newValue,
  }) = _BodyChanged;

  const factory NotificationEvent.noteChanged({
    required String newValue,
  }) = _NoteChanged;

  const factory NotificationEvent.showNotificationChanged({
    required bool show,
  }) = _ShowNotificationChanged;

  const factory NotificationEvent.showOtherImages({
    required bool show,
  }) = _ShowOtherImages;

  const factory NotificationEvent.imageChanged({
    required String newValue,
  }) = _ImageChanged;

  const factory NotificationEvent.saveChanges() = _SaveChanges;

  // Custom Specific
  const factory NotificationEvent.itemTypeChanged({
    required AppNotificationItemType newValue,
  }) = _ItemTypeChanged;

  const factory NotificationEvent.keySelected({
    required String keyName,
  }) = _KeySelected;

  const factory NotificationEvent.customDateChanged({
    required DateTime newValue,
}) = _CustomDateChanged;
}