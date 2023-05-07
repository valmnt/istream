import 'package:flutter/material.dart';
import 'package:istream/src/shared/colors.dart';
import 'package:istream/src/shared/loader.dart';

const tabs = <Tab>[
  Tab(
    icon: Icon(Icons.file_copy),
  ),
  Tab(
    icon: Icon(Icons.cloud_outlined),
  ),
];

class AddM3U extends StatelessWidget {
  final Function openPicker;
  final Function(String url) getNetworkFile;
  final bool isLoading;

  const AddM3U(
      {Key? key,
      required this.openPicker,
      required this.getNetworkFile,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          builder: (BuildContext context) {
            return Stack(
              children: [
                _modal(context),
                Visibility(
                  visible: isLoading,
                  child: const Loader(width: 100, height: 100),
                ),
              ],
            );
          },
        );
      },
      backgroundColor: primary,
      child: const Icon(Icons.add),
    );
  }

  Widget _modal(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondary,
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tertiary.withOpacity(0.8),
                ),
                height: MediaQuery.of(context).size.height * 0.5,
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
                      backgroundColor: tertiary,
                      elevation: 0,
                      surfaceTintColor: secondary,
                      foregroundColor: secondary,
                      automaticallyImplyLeading: false,
                      title: const Text('Upload your data!'),
                      bottom: TabBar(
                        tabs: tabs,
                        indicatorColor: primary,
                      ),
                    ),
                    body: TabBarView(
                      children: <Widget>[
                        _firstTab(context),
                        _secondTab(context)
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _firstTab(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => {
          openPicker(),
          Navigator.of(context).pop(),
        },
        child: Text(
          "Select your file 📝",
          style: TextStyle(
              color: secondary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _secondTab(BuildContext context) {
    final urlController = TextEditingController();
    final webFormKey = GlobalKey<FormState>();

    return Form(
        key: webFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Insert your m3u url",
              style: TextStyle(
                  color: secondary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextFormField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'URL',
                labelStyle: TextStyle(color: primary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primary),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              cursorColor: primary,
              onTap: () => {print("TOUCHCHCHCH FIELD")},
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  RegExp exp = RegExp(
                      r'(https?://(www.)?[-a-zA-Z0-9@:%.+~#=]{1,256}.[a-zA-Z0-9()]{1,6}\b[-a-zA-Z0-9()@:%+.~#?&//=]*)');
                  RegExpMatch? match = exp.firstMatch(value);
                  if (match != null) {
                    exp = RegExp(r'm3u');
                    match = exp.firstMatch(value);
                    if (match != null) {
                      return null;
                    }
                    return "Not a m3u URL";
                  }
                  return "Not a URL";
                }
                return "Field is empty";
              },
              style: TextStyle(
                color: secondary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                if (webFormKey.currentState!.validate()) {
                  getNetworkFile(urlController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Upload",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
            ),
          ],
        ));
  }
}
