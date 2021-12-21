import 'package:flutter/material.dart';
import 'package:morningstar/domain/assets.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Morningstar\n\n',
                  style: theme.textTheme.headline5!.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'A CODM Guide',
                      style: theme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(10),
              child: Image.asset(
                Assets.getCODMLogoPath('codm-full-logo.png'),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
