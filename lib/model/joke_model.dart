import 'dart:convert';

class JokeModel {
  JokeModel({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
  });

  final int id;
  final String type;
  final String setup;
  final String punchline;

  factory JokeModel.fromMap(Map<String, dynamic> json) => JokeModel(
        id: json["id"],
        type: json["type"],
        setup: json["setup"],
        punchline: json["punchline"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "setup": setup,
        "punchline": punchline,
      };
}

List<JokeModel> jokesFromJson(String str) => List<JokeModel>.from(
    json.decode(str).map((x) => JokeModel.fromMap(x)));
