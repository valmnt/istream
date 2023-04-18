import 'package:istream/src/services/parse_m3u.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void addChannel(Channel channel) async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? channels = prefs.getStringList("channels");
    if (channels != null) {
      prefs.setStringList("channels", [...channels, channel.title]);
    } else {
      prefs.setStringList("channels", [channel.title]);
    }
    prefs.setStringList(
        channel.title, [channel.playlists.link, channel.playlists.logo]);
  }

  void addMultipleChannels(List<Channel> channels) async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? prefsChannels = prefs.getStringList("channels");
    // prefsChannels!.removeRange(0, prefsChannels.length);

    if (prefsChannels != null) {
      prefs.setStringList(
          "channels", [...prefsChannels, ...channels.map((it) => it.title)]);
    } else {
      prefs.setStringList("channels", [...channels.map((it) => it.title)]);
    }
    for (var channel in channels) {
      prefs.setStringList(
          channel.title, [channel.playlists.link, channel.playlists.logo]);
    }
  }

  void deleteChannel(Channel channel) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(channel.title);
    final List<String>? channels = prefs.getStringList("channels");
    if (channels != null) {
      channels.remove(channel.title);
      prefs.setStringList("channels", channels);
    }
  }
}
