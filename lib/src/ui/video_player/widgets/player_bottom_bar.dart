import 'package:flutter/material.dart';
import 'package:istream/src/resources/colors.dart';

class PlayerBottomBar extends StatelessWidget {
  final bool isPlaying;
  final Function()? onPlayPause;

  const PlayerBottomBar({
    Key? key,
    required this.isPlaying,
    required this.onPlayPause,
  }) : super(key: key);

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
      height: MediaQuery.of(context).size.height * 0.2,
      child: BottomAppBar(
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent.withOpacity(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: secondary,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
              onPressed: onPlayPause,
            )
          ],
        ),
      ),
    );
  }
}
