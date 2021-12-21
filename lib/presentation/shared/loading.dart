import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool useScaffold;
  const Loading({Key? key, this.useScaffold = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Center(
          child: CircularProgressIndicator(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: const Text('Loading', textAlign: TextAlign.center),
        ),
      ],
    );
    if (!useScaffold) return body;
    return Scaffold(body: body);
  }
}
