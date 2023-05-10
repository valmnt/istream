import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:istream/src/shared/colors.dart';
import 'package:istream/src/ui/onboarding/onboarding_view_model.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  OnboardingViewState createState() => OnboardingViewState();
}

class OnboardingViewState extends State<OnboardingView> {
  final OnboardingViewModel _onboardingViewModel = OnboardingViewModel();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      headerBackgroundColor: tertiary,
      pageBackgroundColor: tertiary,
      finishButtonText: 'Enjoy',
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: primary,
      ),
      onFinish: () {
        _onboardingViewModel.setOnboardingCompleted();
        Navigator.of(context).pushReplacementNamed("/home");
      },
      skipTextButton: Text(
        'Skip',
        style: TextStyle(color: primary),
      ),
      background: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.asset(
            'assets/images/developer.png',
            width: 400,
            height: 400,
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(
              'assets/images/organize.png',
              width: 400,
              height: 400,
            )),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(
              'assets/images/download.png',
              width: 400,
              height: 400,
            )),
      ],
      totalPage: 3,
      speed: 1.8,
      pageBodies: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              Text(
                "Enjoy simplified organization of your multimedia content with our M3U-compatible application.",
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              Text(
                'The M3U format is a playlist file used for organizing and playing multimedia content.',
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              Text(
                "All you have to do is add your M3U files or url and enjoy!",
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
