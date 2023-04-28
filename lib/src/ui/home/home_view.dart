import 'package:flutter/material.dart';
import 'package:istream/src/ui/add_m3u/add_m3u_view.dart';
import 'package:istream/src/ui/video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'home_viewmodel.dart';

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
                                  builder: (context) => VideoPlayer(
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
            floatingActionButton: const AddM3UView(),
          );
        }));
  }
}
