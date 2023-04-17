import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'pokenary',
      home: Scaffold(
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {},
    );
  }
}
