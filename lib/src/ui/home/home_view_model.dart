import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:istream/src/models/channel.dart';
import 'package:istream/src/services/parse_m3u_service.dart';
import 'package:istream/src/services/preferences_service.dart';

class HomeViewModel extends ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();
  final ParseM3UService _parseM3UService = ParseM3UService();

  late List<Channel> channelList = [];

  void openPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["m3u"],
    );

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      _preferencesService
          .addMultipleChannels(await _parseM3UService.file(file));
      getChannels();
    } else {
      // User canceled the picker
    }
  }

  void getNetworkFile(String url) async {
    _preferencesService.addMultipleChannels(await _parseM3UService.link(url));
    notifyListeners();
  }

  void getChannels() async {
    channelList += await _preferencesService.getChannels();
    notifyListeners();
  }
}
