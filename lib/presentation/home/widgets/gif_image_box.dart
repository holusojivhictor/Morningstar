import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:morningstar/presentation/shared/loading.dart';

class GifImage extends StatelessWidget {
  const GifImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final height = isPortrait ? mediaQuery.size.height * 0.298 : mediaQuery.size.height * 0.8;
    final width = mediaQuery.size.width;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          height: height,
          width: width,
          child: BlocBuilder<PreloadBloc, PreloadState>(
            builder: (context, state) => state.map(
              loading: (_) => const Loading(),
              loaded: (state) => ClipRect(child: Image.asset(state.assetName), clipper: RectClipper()),
            ),
          ),
        ),
      ),
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width, size.height - 10);
  }
}