import 'dart:io';

import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:http/http.dart' as http;

class Playlist {
  const Playlist({required this.link, required this.logo});

  final String link;
  final String logo;
}

class Channel {
  const Channel(this.playlists, this.title);

  final Playlist playlists;
  final String title;
}

class ParseM3U {
  Future<List<Channel>> file(File file) async {
    final lines = await file.readAsLines();
    final m3u = await parseFile(filter(lines));
    return getChannels(m3u);
  }

  Future<List<Channel>> link(Uri url) async {
    final response = await http.get(url);
    final m3u = await M3uParser.parse(filter(response.body.split('\n')));
    return getChannels(m3u);
  }

  String filter(List<String> lines) {
    return lines
        .where((line) => !line.contains("EXTVLCOPT"))
        .toList()
        .join('\n');
  }

  List<Channel> getChannels(List<M3uGenericEntry> m3u) {
    final List<Channel> channels = [];

    for (final entry in m3u) {
      var playlist =
          Playlist(link: entry.link, logo: entry.attributes['tvg-logo'] ?? "");

      var title = entry.title.isNotEmpty
          ? entry.title
          : entry.attributes['tvg-id'] ?? "";

      channels.add(Channel(playlist, title));
    }

    return channels;
  }
}
