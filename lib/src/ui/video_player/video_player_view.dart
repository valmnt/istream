import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:istream/src/resources/colors.dart';
import 'package:istream/src/shared/loader.dart';
import 'package:istream/src/ui/video_player/video_player_view_model.dart';
import 'package:istream/src/ui/video_player/widgets/player_bottom_bar.dart';
import 'package:istream/src/ui/video_player/widgets/player_top_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.url, required this.title});

  final String title;
  final String url;

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayerView> {
  late VideoPlayerViewModel _videoPlayerViewModel;
  late VlcPlayerController _vlcPlayerController;
  late final Stream<Duration> _positionStream;

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    _vlcPlayerController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    _positionStream = Stream.periodic(const Duration(milliseconds: 500),
        (_) => _vlcPlayerController.value.position);

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
    return ChangeNotifierProvider<VideoPlayerViewModel>(
        create: (_) => VideoPlayerViewModel(),
        child: Builder(builder: (BuildContext privateContext) {
          _videoPlayerViewModel =
              Provider.of<VideoPlayerViewModel>(privateContext, listen: true);
          return GestureDetector(
              onTap: () => {_videoPlayerViewModel.toggleOverlay()},
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
                              virtualDisplay: false,
                              aspectRatio: 16 / 9,
                            )),
                      ),
                      Positioned.fill(
                          child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: _videoPlayerViewModel.showOverlay
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
                                  title: widget.title,
                                  backButtonIcon: Icons.close,
                                  onBackButtonPressed: () => {
                                    _vlcPlayerController.pause(),
                                    Navigator.of(context).pop()
                                  },
                                ));
                          })),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Consumer<VideoPlayerViewModel>(
                            builder: (context, viewModel, child) {
                          return Visibility(
                              visible: viewModel.showOverlay || !isLoaded,
                              maintainState: true,
                              child: StreamBuilder<Duration>(
                                stream: _positionStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<Duration> snapshot) {
                                  if (_vlcPlayerController.value.duration ==
                                              const Duration(seconds: 0) &&
                                          snapshot.data ==
                                              const Duration(seconds: 0) ||
                                      snapshot.data == null) {
                                    return const Center(
                                      child: Loader(width: 50, height: 52),
                                    );
                                  }
                                  if (!isLoaded) isLoaded = true;
                                  if (_vlcPlayerController
                                                  .value.duration.inSeconds -
                                              1 ==
                                          snapshot.data?.inSeconds &&
                                      _vlcPlayerController
                                              .value.duration.inSeconds !=
                                          0 &&
                                      isLoaded) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                  return Visibility(
                                      visible: viewModel.showOverlay,
                                      child: PlayerBottomBar(
                                        isLive: _vlcPlayerController
                                                    .value.duration ==
                                                const Duration(seconds: 0) &&
                                            snapshot.data !=
                                                const Duration(seconds: 0),
                                        totalProgression:
                                            _vlcPlayerController.value.duration,
                                        progression: snapshot.data ??
                                            const Duration(seconds: 0),
                                        isPlaying: viewModel.isPaused,
                                        onPlayPause: () {
                                          viewModel.isPaused
                                              ? _vlcPlayerController.pause()
                                              : _vlcPlayerController.play();

                                          viewModel.togglePause();
                                        },
                                        onSeek: (duration) {
                                          _vlcPlayerController.seekTo(duration);
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
        }));
  }
}
