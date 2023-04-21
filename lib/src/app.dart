import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:istream/src/ui/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pokenary',
      home: Scaffold(
        body: Center(
          child: Home(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {},
    );
  }
}
