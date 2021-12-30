import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morningstar/domain/assets.dart';
import 'package:morningstar/presentation/shared/loading.dart';
import 'package:morningstar/theme.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBox extends StatefulWidget {
  const VideoPlayerBox({Key? key}) : super(key: key);

  @override
  State<VideoPlayerBox> createState() => _VideoPlayerBoxState();
}

class _VideoPlayerBoxState extends State<VideoPlayerBox> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _videoController =  VideoPlayerController.asset(Assets.getVideoPath('home-playback.mp4'));
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.play();
    _videoController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final height = isPortrait ? mediaQuery.size.height * 0.265 : mediaQuery.size.height;
    final width = mediaQuery.size.width * 0.9;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: height,
          width: width,
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: ClipRect(child: VideoPlayer(_videoController), clipper: RectClipper()),
                );
              } else {
                return const Loading();
              }
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
