import 'dart:convert';

import 'package:http/http.dart' as http;

class NorrisJokeService {
  final String _randomJokeURL = "https://api.chucknorris.io/jokes/random";

  Future<String> fetchNorrisJoke() async {
    var response = await http.get(Uri.parse(_randomJokeURL));
    Map<String, dynamic> json = jsonDecode(response.body);
    return json["value"];
  }
}
