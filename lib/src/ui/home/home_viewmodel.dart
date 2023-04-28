import 'package:flutter/material.dart';
import 'package:istream/src/models/channel.dart';
import 'package:istream/src/services/preferences_service.dart';

class HomeViewModel extends ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();

  late List<Channel> channelList = [];

  void getChannels() async {
    channelList += await _preferencesService.getChannels();
    notifyListeners();
  }
}
