import 'dart:ui';

import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:istream/src/resources/colors.dart';
import 'package:istream/src/ui/video_player/video_player_view.dart';

class ChannelCard extends StatelessWidget {
  final String title;
  final String url;
  final Function() onDelete;

  const ChannelCard(
      {super.key,
      required this.title,
      required this.url,
      required this.onDelete});

  void reponsiveWidth() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoPlayerView(
                  url: url,
                  title: title,
                )))
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: secondary,
          image: const DecorationImage(
            image: AssetImage('assets/images/play.jpg'),
            fit: BoxFit.fitHeight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: AppPopupMenu<int>(
                        menuItems: const [
                          PopupMenuItem(
                            value: 0,
                            child: Text('Delete'),
                          ),
                        ],
                        initialValue: 0,
                        onSelected: (int value) {
                          if (value == 0) {
                            onDelete();
                          }
                        },
                        elevation: 5,
                        icon: const Icon(Icons.more_vert_sharp),
                        offset: const Offset(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: primary,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: secondary,
                              fontSize: 18,
                            ),
                          ),
                        )),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
