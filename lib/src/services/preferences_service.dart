import 'package:istream/src/models/channel.dart';
import 'package:istream/src/models/playlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void addChannel(Channel channel) async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? channels = prefs.getStringList("channels");
    if (channels != null) {
      if (!channels.contains(channel.title)) {
        prefs.setStringList("channels", [...channels, channel.title]);
        prefs.setStringList(
            channel.title, [channel.playlists.link, channel.playlists.logo]);
      }
    } else {
      prefs.setStringList("channels", [channel.title]);
      prefs.setStringList(
          channel.title, [channel.playlists.link, channel.playlists.logo]);
    }
  }

  void addMultipleChannels(List<Channel> channels) async {
    for (var channel in channels) {
      addChannel(channel);
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

  Future<List<Channel>> getChannels() async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? prefsChannels = prefs.getStringList("channels");

    final List<Channel> channels = [];

    if (prefsChannels != null) {
      for (var channel in prefsChannels) {
        var tempChannel = prefs.getStringList(channel);
        channels.add(Channel(
            Playlist(link: tempChannel!.first, logo: tempChannel.last),
            channel));
      }
    }

    return channels;
  }
}
