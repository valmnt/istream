import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:istream/src/resources/colors.dart';

class PlayerBottomBar extends StatelessWidget {
  final Function()? onPlayPause;
  final Function(Duration)? onSeek;
  final bool isLive;
  final bool isPlaying;
  final Duration totalProgression;
  final Duration progression;

  const PlayerBottomBar(
      {Key? key,
      required this.isLive,
      required this.onPlayPause,
      required this.onSeek,
      required this.isPlaying,
      required this.totalProgression,
      required this.progression})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: BottomAppBar(
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent.withOpacity(0),
        elevation: 0,
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
            if (isLive)
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Live 🔴",
                        style: TextStyle(
                            color: secondary, fontWeight: FontWeight.bold),
                      )))
            else
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: ProgressBar(
                    progressBarColor: primary,
                    thumbColor: primary,
                    baseBarColor: Colors.grey.withOpacity(0.8),
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
