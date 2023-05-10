import 'package:flutter/material.dart';
import 'package:istream/src/shared/colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loader extends StatelessWidget {
  final double width;
  final double height;

  const Loader({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: [primary],
          strokeWidth: 5,
        ));
  }
}
