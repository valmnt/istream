import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:istream/src/services/parse_m3u.dart';
import 'package:istream/src/services/preferences.dart';

class M3UModel extends ChangeNotifier {
  late List<Channel> channelList = [];

  void openPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["m3u"],
    );

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      Preferences().addMultipleChannels(await ParseM3U().file(file));
      notifyListeners();
    } else {
      // User canceled the picker
    }
  }

  void getNetworkFile(String url) async {
    Preferences().addMultipleChannels(await ParseM3U().link(url));
    notifyListeners();
  }

  void getChannels() async {
    channelList += await Preferences().getChannels();
    notifyListeners();
  }
}
