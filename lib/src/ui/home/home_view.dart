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
  late HomeViewModel _model;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Builder(builder: (BuildContext privateContext) {
          _model = Provider.of<HomeViewModel>(privateContext, listen: true);
          _model.getChannels();
          return Scaffold(
            body: Consumer<HomeViewModel>(builder: (context, m3u, child) {
              return ListView.builder(
                  itemCount: _model.channelList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VideoPlayerView(
                                        url: _model
                                            .channelList[index].playlists.link,
                                        title: _model.channelList[index].title,
                                      )));
                            },
                            title: Text(_model.channelList[index].title),
                            subtitle:
                                Text(_model.channelList[index].playlists.link),
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(_model
                                    .channelList[index].playlists.logo))));
                  });
            }),
            floatingActionButton: AddM3U(
              openPicker: () => {_model.openPicker()},
              getNetworkFile: (url) => {_model.getNetworkFile(url)},
            ),
          );
        }));
  }
}
