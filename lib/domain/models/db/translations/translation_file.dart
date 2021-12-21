import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models.dart';

part 'translation_file.freezed.dart';
part 'translation_file.g.dart';

@freezed
class TranslationFile with _$TranslationFile {
  factory TranslationFile({
    required List<TranslationSoldierFile> soldiers,
  }) = _TranslationFile;

  factory TranslationFile.fromJson(Map<String, dynamic> json) => _$TranslationFileFromJson(json);
}