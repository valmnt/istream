import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:istream/src/ui/video_player/video_player_view_model.dart';
import 'package:istream/src/ui/video_player/widgets/player_bottom_bar.dart';
import 'package:istream/src/ui/video_player/widgets/player_navbar.dart';
import 'package:provider/provider.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.url, required this.title});

  final String url;

  final String title;

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayerView> {
  final VideoPlayerViewModel _videoPlayerViewModel = VideoPlayerViewModel();
  late VlcPlayerController _vlcPlayerController;

  bool isPlaying = true;
  bool isDisposing = false;

  @override
  void initState() {
    super.initState();

    _vlcPlayerController = VlcPlayerController.network(
      widget.url,
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    super.dispose();
    await _vlcPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {_videoPlayerViewModel.resetTimer()},
        child: ChangeNotifierProvider<VideoPlayerViewModel>(
          create: (_) => _videoPlayerViewModel,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: VlcPlayer(
                          controller: _vlcPlayerController,
                          aspectRatio: 16 / 9,
                          placeholder:
                              const Center(child: CircularProgressIndicator()),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Consumer<VideoPlayerViewModel>(
                        builder: (context, viewModel, child) {
                      viewModel.hideBottomBar();

                      return Visibility(
                          visible: _videoPlayerViewModel.showBottomAppBar,
                          child: PlayerBottomBar(
                            isPlaying: viewModel.isPaused,
                            onPlayPause: () {
                              viewModel.isPaused
                                  ? _vlcPlayerController.pause()
                                  : _vlcPlayerController.play();

                              viewModel.togglePause();
                            },
                          ));
                    }),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Consumer<VideoPlayerViewModel>(
                          builder: (context, viewModel, child) {
                        return Visibility(
                            visible: _videoPlayerViewModel.showBottomAppBar,
                            child: PlayerNavBar(
                              title: widget.title,
                              backButtonIcon: Icons.close,
                              onBackButtonPressed: () => {
                                _vlcPlayerController.pause(),
                                Navigator.of(context).pop()
                              },
                            ));
                      })),
                ],
              ),
            ),
          ),
        ));
  }
}
