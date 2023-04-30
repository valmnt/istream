import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:istream/src/resources/colors.dart';

class PlayerBottomBar extends StatelessWidget {
  final Function()? onPlayPause;
  final Function(Duration)? onSeek;
  final bool isPlaying;
  final Duration totalProgression;
  final Duration progression;

  const PlayerBottomBar(
      {Key? key,
      required this.onPlayPause,
      required this.onSeek,
      required this.isPlaying,
      required this.totalProgression,
      required this.progression})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.transparent],
          stops: [0.6, 2],
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.30,
      child: BottomAppBar(
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent.withOpacity(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: IconButton(
                color: secondary,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                onPressed: onPlayPause,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: ProgressBar(
                  progressBarColor: primary,
                  thumbColor: primary,
                  bufferedBarColor: secondary,
                  baseBarColor: backgroundColor,
                  timeLabelTextStyle: const TextStyle(color: secondary),
                  progress: progression,
                  total: totalProgression,
                  onSeek: onSeek),
            )
          ],
        ),
      ),
    );
  }
}
