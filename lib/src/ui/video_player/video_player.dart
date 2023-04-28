import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:istream/src/resources/colors.dart';
import 'package:provider/provider.dart';

class PlayerState extends ChangeNotifier {
  bool showBottomAppBar = true;
  bool _isPaused = true;
  Timer? _timer;

  bool get isPaused => _isPaused;

  set isPaused(bool value) {
    _isPaused = value;
    notifyListeners();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    showBottomAppBar = true;
    notifyListeners();
    hideBottomBar();
  }

  void hideBottomBar() {
    _timer = Timer(const Duration(seconds: 3), () {
      showBottomAppBar = false;
      notifyListeners();
    });
  }

  void resetTimer() {
    _startTimer();
  }
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.url, required this.title});

  final String? url;

  final String? title;

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
  PlayerState? _playerState;
  VlcPlayerController? _videoPlayerController;

  bool isPlaying = true;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
      widget.url ?? "",
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() async {
    await _videoPlayerController?.dispose();
    _playerState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {_playerState?.resetTimer()},
        child: ChangeNotifierProvider<PlayerState>(
          create: (_) => PlayerState(),
          child: Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: VlcPlayer(
                          controller: _videoPlayerController!,
                          aspectRatio: 16 / 9,
                          placeholder:
                              const Center(child: CircularProgressIndicator()),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Consumer<PlayerState>(
                        builder: (context, playerState, child) {
                      if (_playerState == null) {
                        _playerState = playerState;
                        _playerState?.hideBottomBar();
                      }

                      return Visibility(
                          visible: _playerState!.showBottomAppBar,
                          child: PlayerBottomBar(
                            isPlaying: playerState.isPaused,
                            onPlayPause: () {
                              playerState.isPaused
                                  ? _videoPlayerController?.pause()
                                  : _videoPlayerController?.play();

                              playerState.togglePause();
                            },
                          ));
                    }),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Consumer<PlayerState>(
                          builder: (context, playerState, child) {
                        return Visibility(
                            visible: _playerState!.showBottomAppBar,
                            child: PlayerNavBar(
                              title: widget.title ?? "",
                              backButtonIcon: Icons.close,
                              onBackButtonPressed: () => {print("onClose")},
                            ));
                      })),
                ],
              ),
            ),
          ),
        ));
  }
}

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

class PlayerNavBar extends StatelessWidget {
  final String title;
  final IconData? backButtonIcon;
  final Function()? onBackButtonPressed;

  const PlayerNavBar({
    super.key,
    required this.title,
    this.backButtonIcon,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
          stops: [0.5, 0.7],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (backButtonIcon != null && onBackButtonPressed != null)
            IconButton(
              color: Colors.white,
              icon: Icon(backButtonIcon),
              onPressed: onBackButtonPressed,
            )
          else
            const SizedBox(width: 48),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
