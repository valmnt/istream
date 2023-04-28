import 'package:flutter/material.dart';
import 'package:istream/src/ui/add_m3u.dart';
import 'package:istream/src/ui/video_player.dart';
import 'package:provider/provider.dart';

import '../models/m3u_model.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();
  late AddM3UModel _model;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddM3UModel>(
        create: (context) => AddM3UModel(),
        child: Builder(builder: (BuildContext privateContext) {
          _model = Provider.of<AddM3UModel>(privateContext, listen: false);

          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              _model.getChannels();
            }
          });

          _model.getChannels();
          return Scaffold(
            body: Consumer<AddM3UModel>(builder: (context, m3u, child) {
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
            floatingActionButton: AddM3UView(),
          );
        }));
  }
}
