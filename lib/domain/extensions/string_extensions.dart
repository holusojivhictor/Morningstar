import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/infrastructure/telemetry/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minio/minio.dart';

extension NullStringExtensions on String? {
  bool get isNullEmptyOrWhitespace => this == null || this!.isEmpty;
  bool get isNotNullEmptyOrWhitespace => !isNullEmptyOrWhitespace;

  bool isValidLength({int minLength = 0, int maxLength = 255}) => isNotNullEmptyOrWhitespace ||this!.length > maxLength || this!.length < minLength;
}

extension StringExtensions on String {
  Future<String?> getImage({String? doc, String? backup, String? dateString, bool isFirst = true}) async {
    final minio = Minio(
      endPoint: 'nyc3.digitaloceanspaces.com',
      accessKey: Secrets.accessKey,
      secretKey: Secrets.secretKey,
    );

    final dateNow = DateTime.now();
    await _getState(this, StateType.bool).then((value) => isFirst = value);

    if (isFirst) {
      var signed = await minio.presignedUrl('GET', 'morningstar', this, expires: 300);
      doc = signed;
    }

    if (isFirst) {
      final dateDownloaded = DateTime.now();
      _saveState('$this-dateDownloaded', StateType.string, name: '$dateDownloaded');
      _saveState(this, StateType.string, name: doc);
      isFirst = false;
      _saveState(this, StateType.bool, state: isFirst);
    }

    await _getState('$this-dateDownloaded', StateType.string).then((value) => dateString = value);

    DateTime dateTimeDownloaded = DateTime.parse(dateString!);

    if (dateNow.isAfter(dateTimeDownloaded.add(const Duration(days: 29)))) {
      isFirst = true;
      _saveState(this, StateType.bool, state: isFirst);
    }

    await _getState(this, StateType.string).then((value) => backup = value);

    return backup != 'None' ? backup : doc;
  }

  void _saveState(String key, StateType type, {bool? state, String? name}) async {
    final prefs = await SharedPreferences.getInstance();

    switch(type) {
      case StateType.string:
        prefs.setString(key, name!);
        break;
      case StateType.bool:
        prefs.setBool('$key-ImageState', state!);
        break;
      default:
        throw Exception('Invalid state type');
    }
  }

  Future<dynamic> _getState(String key, StateType type) async {
    final prefs = await SharedPreferences.getInstance();

    switch (type) {
      case StateType.string:
        final value = prefs.getString(key);
        return value ?? 'None';
      case StateType.bool:
        final value = prefs.getBool('$key-ImageState');
        return value ?? true;
    }
  }
}