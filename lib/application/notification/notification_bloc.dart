import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';
import 'package:morningstar/domain/services/logging_service.dart';
import 'package:morningstar/domain/services/morningstar_service.dart';
import 'package:morningstar/domain/services/data_service.dart';
import 'package:morningstar/domain/services/locale_service.dart';
import 'package:morningstar/domain/services/notification_service.dart';
import 'package:morningstar/domain/services/settings_service.dart';
import 'package:morningstar/domain/services/telemetry_service.dart';

part 'notification_bloc.freezed.dart';
part 'notification_event.dart';
part 'notification_state.dart';

// Dummy state
const _initialState = NotificationState.dailyCheckIn(
  images: [],
  showNotification: true,
);

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final DataService _dataService;
  final NotificationService _notificationService;
  final MorningStarService _morningStarService;
  final LocaleService _localeService;
  final TelemetryService _telemetryService;
  final SettingsService _settingsService;
  final LoggingService _loggingService;

  final NotificationsBloc _notificationsBloc;

  static int get maxTitleLength => 40;

  static int get maxBodyLength => 40;

  static int get maxNoteLength => 100;

  NotificationBloc(
    this._dataService,
    this._notificationService,
    this._morningStarService,
    this._localeService,
    this._telemetryService,
    this._settingsService,
    this._loggingService,
    this._notificationsBloc,
  ) : super(_initialState);

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    // TODO: Handle Recurring notifications
    final s = await event.map(
      add: (e) async => _buildAddState(e.defaultTitle, e.defaultBody),
      edit: (e) async => _buildEditState(e.key, e.type),
      typeChanged: (e) async => _typeChanged(e.newValue),
      titleChanged: (e) async => state.copyWith.call(
        title: e.newValue,
        isTitleValid: _isTitleValid(e.newValue),
        isTitleDirty: true,
      ),
      bodyChanged: (e) async => state.copyWith.call(
        body: e.newValue,
        isBodyValid: _isBodyValid(e.newValue),
        isBodyDirty: true,
      ),
      noteChanged: (e) async => state.copyWith.call(
        note: e.newValue,
        isNoteValid: _isNoteValid(e.newValue),
        isNoteDirty: true,
      ),
      showNotificationChanged: (e) async => state.copyWith.call(showNotification: e.show),
      itemTypeChanged: (e) async => state.maybeMap(
        custom: (s) => _itemTypeChanged(e.newValue),
        orElse: () => state,
      ),
      saveChanges: (e) async => _saveChanges(),
      showOtherImages: (e) async => state.copyWith.call(showOtherImages: e.show),
      imageChanged: (e) async {
        final images = state.images.map((el) => el.copyWith.call(isSelected: el.image == e.newValue)).toList();
        return state.copyWith.call(images: images);
      },
      keySelected: (e) async => _itemKeySelected(e.keyName),
      customDateChanged: (e) async => state.maybeMap(
        custom: (s) => s.copyWith.call(scheduledDate: e.newValue),
        orElse: () => state,
      ),
    );

    yield s;
  }

  bool _isTitleValid(String value) => value.isValidLength(maxLength: maxTitleLength);

  bool _isBodyValid(String value) => value.isValidLength(maxLength: maxBodyLength);

  bool _isNoteValid(String? value) => value.isNullEmptyOrWhitespace || value.isValidLength(maxLength: maxNoteLength);

  NotificationState _buildAddState(String title, String body) {
    return NotificationState.dailyCheckIn(
      title: title,
      body: body,
      isTitleValid: true,
      isBodyValid: true,
      images: _getImagesForDailyCheckIn(),
      showNotification: true,
    );
  }

  NotificationState _buildEditState(int key, AppNotificationType type) {
    final item = _dataService.getNotification(key, type);
    NotificationState state;
    final images = <NotificationItemImage>[];
    switch (item.type) {
      case AppNotificationType.custom:
        images.addAll(_getImagesForCustomNotifications(itemKey: item.itemKey, selectedImage: item.image));
        state = NotificationState.custom(
          itemType: item.notificationItemType!,
          scheduledDate: item.completesAt,
          language: _localeService.getLocaleWithoutLang(),
          useTwentyFourHoursFormat: _settingsService.useTwentyFourHoursFormat,
        );
        break;
      case AppNotificationType.dailyCheckIn:
        images.addAll(_getImagesForDailyCheckIn(itemKey: item.itemKey, selectedImage: item.image));
        state = const NotificationState.dailyCheckIn();
        break;
      default:
        throw Exception('Invalid notification type = ${item.type}');
    }

    return state.copyWith.call(
      key: item.key,
      title: item.title,
      body: item.body,
      note: item.note ?? '',
      images: images,
      showNotification: item.showNotification,
      isTitleValid: _isTitleValid(item.title),
      isTitleDirty: item.title.isNotNullEmptyOrWhitespace,
      isBodyValid: _isBodyValid(item.body),
      isBodyDirty: item.body.isNotNullEmptyOrWhitespace,
      isNoteValid: _isNoteValid(item.note),
      isNoteDirty: item.note.isNotNullEmptyOrWhitespace,
    );
  }

  NotificationState _typeChanged(AppNotificationType newValue) {
    // We can't allow type change after the notification has been created
    if (state.key != null) {
      return state;
    }

    NotificationState updatedState;
    final images = <NotificationItemImage>[];
    switch (newValue) {
      case AppNotificationType.custom:
        images.addAll(_getImagesForCustomNotifications());
        updatedState = NotificationState.custom(
          itemType: AppNotificationItemType.soldier,
          scheduledDate: DateTime.now().add(const Duration(days: 1)),
          language: _localeService.getLocaleWithoutLang(),
          useTwentyFourHoursFormat: _settingsService.useTwentyFourHoursFormat,
        );
        break;
      case AppNotificationType.dailyCheckIn:
        images.addAll(_getImagesForDailyCheckIn());
        updatedState = const NotificationState.dailyCheckIn();
        break;
      default:
        throw Exception('The provided app notification type = $newValue is not valid');
    }

    return updatedState.copyWith.call(
      images: images,
      showNotification: state.showNotification,
      title: state.title,
      body: state.body,
      note: state.note,
      isTitleValid: state.isTitleValid,
      isTitleDirty: state.isTitleDirty,
      isBodyValid: state.isBodyValid,
      isBodyDirty: state.isBodyDirty,
      isNoteValid: state.isNoteValid,
      isNoteDirty: state.isNoteDirty,
    );
  }

  NotificationState _itemTypeChanged(AppNotificationItemType newValue) {
    return state.maybeMap(
      custom: (s) {
        final images = <NotificationItemImage>[];
        switch (newValue) {
          case AppNotificationItemType.soldier:
            // final soldier = _morningStarService.getSoldiersForCard().first;
            images.add(NotificationItemImage(itemKey: 'codm-logo', image: Assets.getCODMLogoPath('codm-logo.png'), isSelected: true));
            break;
          // TODO: Add weapon case
          case AppNotificationItemType.bonus:
            images.add(NotificationItemImage(itemKey: 'codm-logo', image: Assets.getCODMLogoPath('codm-logo.png'), isSelected: true));
            break;
          default:
            throw Exception('The provided notification item type = $newValue is not valid');
        }

        return s.copyWith.call(images: images, itemType: newValue);
      },
      orElse: () => state,
    );
  }

  NotificationState _itemKeySelected(String itemKey) {
    return state.maybeMap(
      custom: (s) {
        final img = _morningStarService.getItemImageFromNotificationItemType(itemKey, s.itemType);
        return s.copyWith.call(images: [NotificationItemImage(itemKey: itemKey, image: img, isSelected: true)]);
      },
      orElse: () => state,
    );
  }

  Future<NotificationState> _saveChanges() async {
    try {
      await state.map(
        custom: _saveCustomNotification,
        dailyCheckIn: _saveDailyCheckInNotification,
      );

      if (state.key == null) {
        await _telemetryService.trackNotificationCreated(state.type);
      } else {
        await _telemetryService.trackNotificationUpdated(state.type);
      }
    } catch (e, s) {
      _loggingService.error(runtimeType, '_saveChanges: Unknown error while saving changes', e, s);
    }
    
    _notificationsBloc.add(const NotificationsEvent.init());

    return state;
  }

  Future<void> _saveCustomNotification(_CustomState s) async {
    final selectedItemKey = _getSelectedItemKey();
    if (s.key != null) {
      final updated = await _dataService.updateCustomNotification(
        s.key!,
        selectedItemKey,
        s.title,
        s.body,
        s.scheduledDate,
        s.showNotification,
        s.itemType,
        note: s.note,
      );
      await _afterNotificationWasUpdated(updated);
      return;
    }

    final notif = await _dataService.saveCustomNotification(
      selectedItemKey,
      s.title,
      s.body,
      s.scheduledDate,
      s.itemType,
      note: s.note,
      showNotification: s.showNotification,
    );
    await _afterNotificationWasCreated(notif);
  }

  Future<void> _saveDailyCheckInNotification(_DailyCheckInState s) async {
    final selectedItemKey = _getSelectedItemKey();
    if (s.key != null) {
      final updated = await _dataService.updateDailyCheckInNotification(
        s.key!,
        selectedItemKey,
        s.title,
        s.body,
        s.showNotification,
        note: s.note,
      );
      await _afterNotificationWasUpdated(updated);
      return;
    }

    final notif = await _dataService.saveDailyCheckInNotification(
      selectedItemKey,
      s.title,
      s.body,
      note: s.note,
      showNotification: s.showNotification,
    );
    await _afterNotificationWasCreated(notif);
  }

  String _getSelectedItemKey() {
    return state.images.firstWhere((el) => el.isSelected).itemKey;
  }

  List<NotificationItemImage> _getImagesForCustomNotifications({String? itemKey, String? selectedImage}) {
    if (selectedImage.isNotNullEmptyOrWhitespace) {
      return [NotificationItemImage(itemKey: itemKey!, image: selectedImage!, isSelected: true)];
    }
    // final soldier = _morningStarService.getSoldiersForCard().first;
    return [NotificationItemImage(itemKey: 'codm-logo', image: Assets.getCODMLogoPath('codm-logo.png'), isSelected: true)];
  }

  List<NotificationItemImage> _getImagesForDailyCheckIn({String? itemKey, String? selectedImage}) {
    // TODO: Fix the culled image
    if (selectedImage.isNotNullEmptyOrWhitespace) {
      return [NotificationItemImage(itemKey: itemKey!, image: selectedImage!, isSelected: true)];
    }
    return [NotificationItemImage(itemKey: 'codm-logo', image: Assets.getCODMLogoPath('codm-logo.png'), isSelected: true)];
  }

  Future<void> _afterNotificationWasCreated(NotificationItem notif) async {
    if (notif.showNotification) {
      await _notificationService.scheduleNotification(notif.key, notif.type, notif.title, notif.body, notif.completesAt);
    }
  }

  Future<void> _afterNotificationWasUpdated(NotificationItem notif) async {
    await _notificationService.cancelNotification(notif.key, notif.type);
    if (notif.showNotification && !notif.remaining.isNegative) {
      await _notificationService.scheduleNotification(notif.key, notif.type, notif.title, notif.body, notif.completesAt);
    }
  }
}
