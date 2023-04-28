import 'dart:async';

import 'package:flutter/material.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  bool showBottomAppBar = true;
  bool _isPaused = true;
  Timer? _timer;

  bool get isPaused => _isPaused;

  set isPaused(bool value) {
    _isPaused = value;
    notifyListeners();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    showBottomAppBar = true;
    notifyListeners();
    hideBottomBar();
  }

  void hideBottomBar() {
    _timer = Timer(const Duration(seconds: 3), () {
      showBottomAppBar = false;
      notifyListeners();
    });
  }

  void resetTimer() {
    _startTimer();
  }
}
