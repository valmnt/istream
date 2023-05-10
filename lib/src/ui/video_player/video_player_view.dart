import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:istream/src/shared/loader.dart';
import 'package:istream/src/ui/video_player/video_player_view_model.dart';
import 'package:istream/src/ui/video_player/widgets/player_bottom_bar.dart';
import 'package:istream/src/ui/video_player/widgets/player_top_bar.dart';
import 'package:provider/provider.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key});

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayerView> {
  VlcPlayerController? _vlcPlayerController;
  Map<String, dynamic>? arguments;
  Stream<Duration>? _positionStream;

  @override
  void dispose() async {
    super.dispose();
    await _vlcPlayerController?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_vlcPlayerController == null) {
      arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      _vlcPlayerController = VlcPlayerController.network(
        arguments!['videoUrl'],
        hwAcc: HwAcc.full,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
      _positionStream = Stream.periodic(const Duration(milliseconds: 500),
          (_) => _vlcPlayerController!.value.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              Provider.of<VideoPlayerViewModel>(context, listen: false)
                  .toggleOverlay()
            },
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
                        controller: _vlcPlayerController!,
                        virtualDisplay: false,
                        aspectRatio: 16 / 9,
                      )),
                ),
                Positioned.fill(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Provider.of<VideoPlayerViewModel>(context).showOverlay
                      ? Colors.black.withOpacity(0.7)
                      : Colors.transparent,
                )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Consumer<VideoPlayerViewModel>(
                        builder: (context, viewModel, child) {
                      return Visibility(
                          visible: viewModel.showOverlay,
                          child: PlayerTopBar(
                              title: arguments?["title"],
                              backButtonIcon: Icons.close,
                              onBackButtonPressed: onPop));
                    })),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Consumer<VideoPlayerViewModel>(
                      builder: (context, viewModel, child) {
                    return Visibility(
                        visible: viewModel.showOverlay || !viewModel.isLoaded,
                        maintainState: true,
                        child: StreamBuilder<Duration>(
                          stream: _positionStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<Duration> snapshot) {
                            if (_vlcPlayerController!.value.duration ==
                                        const Duration(seconds: 0) &&
                                    snapshot.data ==
                                        const Duration(seconds: 0) ||
                                snapshot.data == null) {
                              return const Center(
                                child: Loader(width: 50, height: 52),
                              );
                            } else if (!viewModel.isLoaded &&
                                snapshot.data != const Duration(seconds: 0)) {
                              viewModel.isLoaded = true;
                            } else if (viewModel.isLoaded &&
                                snapshot.data == const Duration(seconds: 0) &&
                                !_vlcPlayerController!.value.isPlaying) {
                              _vlcPlayerController!.stop();
                              _vlcPlayerController!.play();
                            }
                            return Visibility(
                                visible: viewModel.showOverlay,
                                child: PlayerBottomBar(
                                  isLive: _vlcPlayerController!
                                                  .value.duration ==
                                              const Duration(seconds: 0) &&
                                          snapshot.data !=
                                              const Duration(seconds: 0) ||
                                      snapshot.data! >
                                          _vlcPlayerController!.value.duration,
                                  totalProgression:
                                      _vlcPlayerController!.value.duration,
                                  progression: snapshot.data ??
                                      const Duration(seconds: 0),
                                  isPlaying: viewModel.isPaused,
                                  onPlayPause: () {
                                    viewModel.isPaused
                                        ? _vlcPlayerController!.pause()
                                        : _vlcPlayerController!.play();

                                    viewModel.togglePause();
                                  },
                                  onSeek: (duration) {
                                    _vlcPlayerController!.seekTo(duration);
                                  },
                                  onDragStart: (details) => {
                                    viewModel.isDragged = true,
                                  },
                                  onDragEnd: () => {
                                    viewModel.isDragged = false,
                                    viewModel.showOverlay = false,
                                    viewModel.toggleOverlay()
                                  },
                                ));
                          },
                        ));
                  }),
                ),
              ],
            ),
          ),
        ));
  }

  void onPop() {
    _vlcPlayerController!.pause();
    Navigator.of(context).pop();
  }
}
