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
  bool isLoading = false;
  String input = "";

  void openPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["m3u"],
    );

    if (result != null) {
      isLoading = true;
      notifyListeners();
      Future.delayed(const Duration(seconds: 1), () async {
        File file = File(result.files.single.path ?? "");
        _channelsService.addMultipleChannels(await _parseM3UService.file(file));
        getChannels();
      });
    } else {
      // User canceled the picker
    }
  }

  void getNetworkFile(String url) async {
    isLoading = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () async {
      _channelsService.addMultipleChannels(await _parseM3UService.link(url));
      getChannels();
    });
  }

  void getChannels() async {
    _allChannels = await _channelsService.getChannels();
    channels = _allChannels;
    if (isLoading && initData) {
      isLoading = false;
    }

    if (!initData) {
      initData = true;
    }
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

  void deleteChannel(Channel channel) {
    _channelsService.deleteChannel(channel);
    _allChannels.remove(channel);
    channels.remove(channel);
    notifyListeners();
  }

  Future<String> fetchJokeForFunnyError() async {
    return await _norrisJokeService.fetchNorrisJoke();
  }
}
