import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:istream/src/resources/colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatelessWidget {
  final int width;
  final int height;

  const Loader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 50,
        height: 52,
        child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: [primary],
          strokeWidth: 5,
        ));
  }
}
