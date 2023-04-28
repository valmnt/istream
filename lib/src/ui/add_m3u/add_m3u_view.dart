import 'package:flutter/material.dart';
import 'package:istream/src/resources/colors.dart';

import 'add_m3u_viewmodel.dart';

const tabs = <Tab>[
  Tab(
    icon: Icon(Icons.cloud_outlined),
  ),
  Tab(
    icon: Icon(Icons.beach_access_sharp),
  ),
  Tab(
    icon: Icon(Icons.brightness_5_sharp),
  ),
];

class AddM3UView extends StatefulWidget {
  const AddM3UView({Key? key}) : super(key: key);

  @override
  AddM3UState createState() => AddM3UState();
}

class AddM3UState extends State<AddM3UView> {
  final AddM3UViewModel _model = AddM3UViewModel();

  final urlController = TextEditingController();

  final webFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: secondary,
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: secondary,
                        ),
                        height: MediaQuery.of(context).size.height / 2,
                        child: DefaultTabController(
                          initialIndex: 1,
                          length: tabs.length,
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: AppBar(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              backgroundColor: primary,
                              elevation: 0,
                              surfaceTintColor: secondary,
                              foregroundColor: secondary,
                              automaticallyImplyLeading: false,
                              title: const Text('Add channels'),
                              bottom: const TabBar(
                                tabs: tabs,
                                indicatorColor: secondary,
                              ),
                            ),
                            body: TabBarView(
                              children: <Widget>[
                                Center(
                                  child: TextButton(
                                      onPressed: () => _model.openPicker(),
                                      child: const Text("Open picker")),
                                ),
                                Center(
                                    child: Form(
                                        key: webFormKey,
                                        child: Column(
                                          children: [
                                            const Text("Insert your m3u URL"),
                                            TextFormField(
                                              controller: urlController,
                                              validator: (value) {
                                                if (value != null) {
                                                  RegExp exp = RegExp(
                                                      r'(https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b[-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)');
                                                  RegExpMatch? match =
                                                      exp.firstMatch(value);
                                                  if (match != null) {
                                                    exp = RegExp(r'm3u');
                                                    match =
                                                        exp.firstMatch(value);
                                                    if (match != null) {
                                                      return null;
                                                    }
                                                    return "Not a m3u URL";
                                                  }
                                                  return "Not a URL";
                                                }
                                                return "Field is empty";
                                              },
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  if (webFormKey.currentState!
                                                      .validate()) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Processing URL')),
                                                    );
                                                    _model.getNetworkFile(
                                                        urlController.text);
                                                  }
                                                },
                                                child: const Text("Send")),
                                          ],
                                        ))),
                                const Center(
                                  child: Text("It's sunny here"),
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            );
          },
        );
      },
      backgroundColor: primary,
      child: const Icon(Icons.add),
    );
  }
}
