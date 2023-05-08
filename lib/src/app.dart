import 'package:flutter/material.dart';
import 'package:istream/src/shared/colors.dart';
import 'package:istream/src/shared/loader.dart';
import 'package:istream/src/ui/home/home_view.dart';
import 'package:istream/src/ui/onboarding/onboarding_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> getOnboardingCompleted() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("onboardingCompleted") != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IStream',
      home: Scaffold(
          backgroundColor: tertiary,
          body: SafeArea(
            child: FutureBuilder(
                future: getOnboardingCompleted(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader(width: 50, height: 50);
                  } else if (snapshot.data ?? false) {
                    return const HomeView();
                  } else {
                    return const OnboardingView();
                  }
                }),
          )),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 1200, name: TABLET),
          const Breakpoint(start: 1201, end: 1920, name: DESKTOP),
        ],
      ),
    );
  }
}
