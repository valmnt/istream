import 'package:flutter/material.dart';
import 'package:istream/src/shared/colors.dart';

class EmptyList extends StatelessWidget {
  final String text;

  const EmptyList({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
