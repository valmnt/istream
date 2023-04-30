import 'package:flutter/material.dart';
import 'package:istream/src/ui/home/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'IStream',
      home: Scaffold(
        body: Center(
          child: HomeView(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {},
    );
  }
}
