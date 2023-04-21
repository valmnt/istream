import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:istream/src/services/parse_m3u.dart';
import 'package:istream/src/services/preferences.dart';
import 'package:istream/src/ui/add_m3u.dart';
import 'package:provider/provider.dart';

import '../models/m3u_model.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();
  late M3UModel _provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => M3UModel(),
        child: Builder(builder: (BuildContext privateContext) {
          _provider = Provider.of<M3UModel>(privateContext, listen: false);

          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              _provider.getChannels();
            }
          });

          _provider.getChannels();
          return Scaffold(
            body: ListView.builder(
                itemCount: _provider.channelList.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                          title: Text(_provider.channelList[index].title),
                          subtitle:
                              Text(_provider.channelList[index].playlists.link),
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(_provider
                                  .channelList[index].playlists.logo))));
                }),
            floatingActionButton: AddM3u(),
          );
        }));
  }
}
