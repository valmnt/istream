import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:istream/src/resources/colors.dart';
import 'package:istream/src/ui/video_player/video_player_view.dart';

class ChannelCard extends StatelessWidget {
  final String title;
  final String url;

  const ChannelCard({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: GestureDetector(
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
                fit: BoxFit.cover,
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondary,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
