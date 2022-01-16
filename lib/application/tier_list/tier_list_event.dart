part of 'tier_list_bloc.dart';

@freezed
class TierListEvent with _$TierListEvent {
  const factory TierListEvent.init({
    @Default(false) bool reset,
  }) = _Init;

  const factory TierListEvent.rowTextChanged({
    required int index,
    required String newValue,
  }) = _RowTextChanged;

  const factory TierListEvent.rowPositionChanged({
    required int index,
    required int newIndex,
  }) = _RowPositionChanged;

  const factory TierListEvent.rowColorChanged({
    required int index,
    required int newColor,
  }) = _RowColorChanged;

  const factory TierListEvent.addNewRow({
    required int index,
    required bool above,
  }) = _AddRow;

  const factory TierListEvent.deleteRow({
    required int index,
  }) = _DeleteRow;

  const factory TierListEvent.clearRow({
    required int index,
  }) = _ClearRow;

  const factory TierListEvent.clearAllRows() = _ClearAllRows;

  const factory TierListEvent.addWeaponToRow({
    required int index,
    required ItemCommon item,
  }) = _AddWeaponToRow;

  const factory TierListEvent.deleteWeaponFromRow({
    required int index,
    required ItemCommon item,
  }) = _DeleteWeaponFromRow;

  const factory TierListEvent.readyToSave({required bool ready}) = _ReadyToSave;

  const factory TierListEvent.screenshotTaken({
    required bool succeed,
    Object? ex,
    StackTrace? trace,
  }) = _ScreenShotTaken;
}
