import 'dart:async';

import 'package:flutter/material.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  bool showBottomAppBar = true;
  bool _isPaused = true;
  Timer? timer;

  bool get isPaused => _isPaused;

  @override
  void dispose() {
    timer = null;
    super.dispose();
  }

  set isPaused(bool value) {
    _isPaused = value;
    notifyListeners();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void _startTimer() {
    timer?.cancel();
    showBottomAppBar = true;
    notifyListeners();
    hideBottomBar();
  }

  void hideBottomBar() {
    timer = Timer(const Duration(seconds: 3), () {
      if (timer != null) {
        showBottomAppBar = false;
        notifyListeners();
      }
    });
  }

  void resetTimer() {
    _startTimer();
  }
}
