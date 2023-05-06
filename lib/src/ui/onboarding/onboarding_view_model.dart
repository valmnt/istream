import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setOnboardingCompleted() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("onboardingCompleted", "true");
  }
}
