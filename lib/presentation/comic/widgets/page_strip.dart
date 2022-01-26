import 'package:flutter/material.dart';
import 'package:morningstar/domain/models/models.dart';
import 'package:morningstar/presentation/shared/utils/size_utils.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'page_card.dart';

class PageStrip extends StatelessWidget {
  final List<ComicPageCardModel> pages;
  const PageStrip({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverWaterfallFlow(
      delegate: SliverChildBuilderDelegate((context, index) => PageCard.item(comicPage: pages[index]),
        childCount: pages.length,
      ),
      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: SizeUtils.getCrossAxisCountForGrids(context, forPortrait: 1, forLandscape: 2),
      ),
    );
  }
}
