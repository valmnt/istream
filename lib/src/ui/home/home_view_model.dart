import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:istream/src/models/channel.dart';
import 'package:istream/src/services/norris_joke_service.dart';
import 'package:istream/src/services/parse_m3u_service.dart';
import 'package:istream/src/services/channel_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ChannelService _channelsService = ChannelService();
  final ParseM3UService _parseM3UService = ParseM3UService();
  final NorrisJokeService _norrisJokeService = NorrisJokeService();

  List<Channel> channels = [];
  List<Channel> _allChannels = [];
  bool initData = false;
  String input = "";

  void openPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["m3u"],
    );

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      _channelsService.addMultipleChannels(await _parseM3UService.file(file));
      getChannels();
    } else {
      // User canceled the picker
    }
  }

  void getNetworkFile(String url) async {
    _channelsService.addMultipleChannels(await _parseM3UService.link(url));
    getChannels();
    notifyListeners();
  }

  void getChannels() async {
    _allChannels = await _channelsService.getChannels();
    channels = _allChannels;
    initData = true;
    notifyListeners();
  }

  void search(String input) {
    this.input = input.toLowerCase();
    var newChannels = _allChannels
        .where((channel) => channel.title.toLowerCase().contains(this.input))
        .toList();

    if (!listEquals(channels, newChannels)) {
      channels = newChannels;
      notifyListeners();
    }
  }

  void deleteChannel(int index) {
    _channelsService.deleteChannel(channels[index]);
    channels.removeAt(index);
    notifyListeners();
  }

  Future<String> fetchJokeForFunnyError() async {
    return await _norrisJokeService.fetchNorrisJoke();
  }
}
