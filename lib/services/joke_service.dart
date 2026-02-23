import 'package:flutter_hello_world/model/joke_model.dart';
import 'package:http/http.dart' as http;

class JokeService {
  final String _url = "https://api.sampleapis.com/jokes/goodJokes";

  Future<List<JokeModel>> getJokes() async {
    var uri = Uri.parse(_url);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return jokesFromJson(response.body);
    } else {
      throw ("Error al obtenir els acudits: ${response.statusCode}");
    }
  }
}
