import 'dart:async';

import 'package:flutter/material.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  bool _isPaused = true;
  bool _isDismissed = false;
  bool showBottomAppBar = false;
  Timer? timer;

  bool get isPaused => _isPaused;

  set isPaused(bool value) {
    _isPaused = value;
    notifyListeners();
  }

  VideoPlayerViewModel() {
    toggleBottomBar();
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

  void toggleBottomBar() async {
    if (!showBottomAppBar) {
      showBottomAppBar = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 4));
      if (!_isDismissed) {
        showBottomAppBar = false;
        notifyListeners();
      }
    }
  }
}
