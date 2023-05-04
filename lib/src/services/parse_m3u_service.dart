import 'dart:io';

import 'package:istream/src/models/channel.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:http/http.dart' as http;

class ParseM3UService {
  Future<List<Channel>> file(File file) async {
    final lines = await file.readAsLines();
    final m3u = await parseFile(_filter(lines));
    return _getChannels(m3u);
  }

  Future<List<Channel>> link(String url) async {
    Uri uri = Uri.parse(url);

    final response = await http.get(uri);
    final m3u = await M3uParser.parse(_filter(response.body.split('\n')));
    return _getChannels(m3u);
  }

  String _filter(List<String> lines) {
    return lines
        .where((line) => !line.contains("EXTVLCOPT"))
        .toList()
        .join('\n');
  }

  List<Channel> _getChannels(List<M3uGenericEntry> m3u) {
    final List<Channel> channels = [];

    for (final entry in m3u) {
      var title =
          entry.title.isNotEmpty ? entry.title : entry.attributes['tvg-id'];

      if (title != "" && title != null && entry.link.isNotEmpty) {
        channels.add(Channel(entry.link, title));
      }
    }

    return channels;
  }
}
