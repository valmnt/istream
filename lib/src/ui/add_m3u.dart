import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:istream/src/models/add_m3u_model.dart';
import 'package:provider/provider.dart';

class AddM3u extends StatelessWidget {
  AddM3u({Key? key}) : super(key: key);

  late AddM3UModel _addM3UModel;

  @override
  Widget build(BuildContext context) {
    _addM3UModel = AddM3UModel();
    return FloatingActionButton.small(
      onPressed: () {
        _addM3UModel.openPicker();
      },
      child: const Icon(Icons.add),
    );
  }
}
