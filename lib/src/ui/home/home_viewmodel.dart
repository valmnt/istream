import 'package:flutter/material.dart';
import 'package:istream/src/services/parse_m3u.dart';
import 'package:istream/src/services/preferences.dart';

class HomeViewModel extends ChangeNotifier {
  late List<Channel> channelList = [];

  void getChannels() async {
    channelList += await Preferences().getChannels();
    notifyListeners();
  }
}
