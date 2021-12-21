import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'soldier_file_model.dart';

part 'soldiers_file.freezed.dart';
part 'soldiers_file.g.dart';

@freezed
class SoldiersFile with _$SoldiersFile {
  factory SoldiersFile({
    required List<SoldierFileModel> soldiers,
  }) = _SoldiersFile;

  factory SoldiersFile.fromJson(Map<String, dynamic> json) => _$SoldiersFileFromJson(json);
}