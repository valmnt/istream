import 'dart:async';

import 'package:flutter/material.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  bool _isPaused = true;
  bool showOverlay = false;
  bool isLoaded = false;
  bool isDragged = false;
  Timer? timer;

  bool get isPaused => _isPaused;

  set isPaused(bool value) {
    _isPaused = value;
    notifyListeners();
  }

  VideoPlayerViewModel() {
    toggleOverlay();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void toggleOverlay() async {
    if (!showOverlay) {
      showOverlay = true;
      notifyListeners();
      timer = Timer(const Duration(seconds: 3), () {
        if (!isDragged) {
          showOverlay = false;
          notifyListeners();
        }
      });
    }
  }
}
