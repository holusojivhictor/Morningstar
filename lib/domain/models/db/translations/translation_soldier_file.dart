import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_soldier_file.freezed.dart';
part 'translation_soldier_file.g.dart';

@freezed
class TranslationSoldierFile with _$TranslationSoldierFile {
  factory TranslationSoldierFile({
    required String key,
    required String name,
  }) = _TranslationSoldierFile;

  factory TranslationSoldierFile.fromJson(Map<String, dynamic> json) => _$TranslationSoldierFileFromJson(json);
}