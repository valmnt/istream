import 'package:flutter/material.dart';
import 'package:istream/src/ui/home/widgets/add_m3u.dart';
import 'package:istream/src/ui/video_player/video_player_view.dart';
import 'package:provider/provider.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeView> {
  late HomeViewModel? _homeViewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Builder(builder: (BuildContext privateContext) {
          _homeViewModel =
              Provider.of<HomeViewModel>(privateContext, listen: true);
          if (_homeViewModel!.channelList.isEmpty) {
            _homeViewModel?.getChannels();
          }
          return Scaffold(
            body: Consumer<HomeViewModel>(builder: (context, viewModel, child) {
              return ListView.builder(
                  itemCount: viewModel.channelList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VideoPlayerView(
                                        url: viewModel
                                            .channelList[index].playlists.link,
                                        title:
                                            viewModel.channelList[index].title,
                                      )));
                            },
                            title: Text(viewModel.channelList[index].title),
                            subtitle: Text(
                                viewModel.channelList[index].playlists.link),
                            leading: const CircleAvatar()));
                  });
            }),
            floatingActionButton: AddM3U(
              openPicker: () => {_homeViewModel?.openPicker()},
              getNetworkFile: (url) => {_homeViewModel?.getNetworkFile(url)},
            ),
          );
        }));
  }
}
