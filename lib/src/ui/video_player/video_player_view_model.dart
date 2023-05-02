import 'dart:async';

import 'package:flutter/material.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  bool _isPaused = true;
  bool _isDismissed = false;
  bool showOverlay = false;
  Timer? timer;

  bool get isPaused => _isPaused;

  set isPaused(bool value) {
    _isPaused = value;
    notifyListeners();
  }

  VideoPlayerViewModel() {
    toggleOverlay();
  }

  @override
  void dispose() {
    _isDismissed = true;
    timer = null;
    super.dispose();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void toggleOverlay() async {
    if (!showOverlay) {
      showOverlay = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 4));
      if (!_isDismissed) {
        showOverlay = false;
        notifyListeners();
      }
    }
  }
}
