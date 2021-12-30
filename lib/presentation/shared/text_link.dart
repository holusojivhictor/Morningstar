import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TextLink extends StatelessWidget {
  final String text;
  final String url;
  final Function? onTap;

  const TextLink({
    Key? key,
    required this.text,
    required this.url,
    this.onTap,
  }) : super(key: key);

  const TextLink.withoutLink({
    Key? key,
    required this.text,
    required this.onTap,
  })  : url = '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => onTap != null ? onTap!() : _launchUrl(url),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
