import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:istream/src/services/parse_m3u.dart';
import 'package:istream/src/services/preferences.dart';

class AddM3UModel {
  void openPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["m3u"],
    );

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      Preferences().addMultipleChannels(await ParseM3U().file(file));
    } else {
      // User canceled the picker
    }
  }

  void getNetworkFile() {
    //TODO: implement Uri textfield
  }
}
