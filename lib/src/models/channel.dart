import 'package:istream/src/models/playlist.dart';

class Channel {
  const Channel(this.playlists, this.title);

  final Playlist playlists;
  final String title;
}
