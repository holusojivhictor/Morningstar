import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/domain/enums/enums.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/comic/comic_page.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../theme.dart';

class ComicCard extends StatelessWidget {
  final String keyName;
  final String name;
  final String image;
  final ComicSeasonType season;

  final double imgWidth;
  final double imgHeight;
  final bool withoutDetails;
  final bool withElevation;

  const ComicCard({
    Key? key,
    required this.keyName,
    required this.name,
    required this.image,
    required this.season,
    this.imgHeight = 180,
    this.imgWidth = 160,
    this.withElevation = true,
  })  : withoutDetails = false,
        super(key: key);

  ComicCard.item({
    Key? key,
    required ComicCardModel comic,
    this.imgHeight = 110,
    this.imgWidth = 175,
    this.withElevation = true,
  })  : keyName = comic.name,
        name = comic.name,
        image = comic.image,
        season = comic.season,
        withoutDetails = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: Styles.comicCardBorderRadius,
      onTap: () => _goToComicPage(context),
      child: Card(
        color: theme.scaffoldBackgroundColor,
        clipBehavior: Clip.hardEdge,
        shape: Styles.mainComicCardShape,
        elevation: withElevation ? Styles.cardTenElevation : 0,
        child: Padding(
          padding: Styles.edgeInsetAll5,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: FadeInImage(
                  width: imgWidth,
                  height: imgHeight,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: MemoryImage(kTransparentImage),
                  image: CachedNetworkImageProvider(image),
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Tooltip(
                  message: name,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              BlocBuilder<ComicsBloc, ComicsState>(
                builder: (context, state) {
                  return state.map(
                    loading: (_) => const Loading(useScaffold: false),
                    loaded: (state) {
                      if (withoutDetails) {
                        return const SizedBox();
                      }
                      return Container(
                        margin: Styles.edgeInsetHorizontal16,
                        child: Column(
                          children: [
                            Text(
                              Assets.translateComicSeasonType(season),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToComicPage(BuildContext context) async {
    final bloc = context.read<ComicBloc>();
    bloc.add(ComicEvent.loadFromKey(key: name));
    final route = MaterialPageRoute(builder: (c) => const ComicPage());
    await Navigator.push(context, route);
    await route.completed;
    bloc.pop();
  }
}
