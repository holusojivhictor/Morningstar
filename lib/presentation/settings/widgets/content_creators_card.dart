import 'package:flutter/material.dart';
import 'package:morningstar/presentation/settings/widgets/settings_card.dart';
import 'package:morningstar/presentation/shared/bullet_link.dart';

import '../../../theme.dart';

class ContentCreatorsCard extends StatelessWidget {
  const ContentCreatorsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.sports_esports, size: 20),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  'Extra',
                  style: theme.textTheme.headline6,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'Extra tidbit',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            margin: Styles.edgeInsetHorizontal16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text('Here are some of the top CODM content creators. Check them out on YouTube.'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Expanded(child: BulletLink(name: 'ParkerYT', url: 'https://www.youtube.com/user/EclipseNoise/videos', hint: true)),
                    Expanded(child: BulletLink(name: 'iFerg', url: 'https://www.youtube.com/c/iFerg/videos')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Expanded(child: BulletLink(name: 'HawksNestYT', url: 'https://www.youtube.com/c/HawksNestYT/videos')),
                    Expanded(child: BulletLink(name: 'Jokesta', url: 'https://www.youtube.com/c/Jokesta/videos')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Expanded(child: BulletLink(name: 'ICECODM', url: 'https://www.youtube.com/c/ICECODM/videos')),
                    Expanded(child: BulletLink(name: 'BobbyPlays', url: 'https://www.youtube.com/c/BobbyPlays/videos')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
