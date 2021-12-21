import 'package:flutter/material.dart';
import 'package:morningstar/presentation/shared/bullet_list.dart';
import 'package:morningstar/presentation/shared/extensions/media_query_extensions.dart';

class InfoDialog extends StatelessWidget {
  final List<String> explanations;
  const InfoDialog({
    Key? key,
    required this.explanations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Information'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).getWidthForDialogs(),
          child: BulletList(items: explanations, fontSize: 13),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
