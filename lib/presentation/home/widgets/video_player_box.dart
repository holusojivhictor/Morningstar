import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morningstar/application/bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBox extends StatelessWidget {
  const VideoPlayerBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final height = isPortrait ? mediaQuery.size.height * 0.298 : mediaQuery.size.height * 0.8;
    final width = mediaQuery.size.width * 0.9;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: height,
          width: width,
          child: BlocBuilder<PreloadBloc, PreloadState>(
            builder: (context, state) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: isPortrait ? 1.75 : 16 / 7,
                    child: ClipRect(child: VideoPlayer(state.controllers[0]!), clipper: RectClipper()),
                  );
                },
              );
            },
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