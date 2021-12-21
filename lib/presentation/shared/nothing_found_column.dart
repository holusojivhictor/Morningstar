import 'package:flutter/material.dart';

import 'nothing_found.dart';

class NothingFoundColumn extends StatelessWidget {
  final String? msg;
  final IconData icon;
  final EdgeInsets padding;
  const NothingFoundColumn({
    Key? key,
    this.msg,
    this.icon = Icons.info,
    this.padding = const EdgeInsets.only(bottom: 30, right: 20, left: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [NothingFound(msg: msg, icon: icon, padding: padding)],
    );
  }
}
