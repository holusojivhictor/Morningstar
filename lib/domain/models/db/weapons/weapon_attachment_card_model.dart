import 'package:morningstar/domain/enums/enums.dart';

class WeaponAttachmentCardModel {
  final String name;
  final AttachmentType type;
  final double unlockLevel;

  WeaponAttachmentCardModel ({
    required this.name,
    required this.type,
    required this.unlockLevel,
  });
}