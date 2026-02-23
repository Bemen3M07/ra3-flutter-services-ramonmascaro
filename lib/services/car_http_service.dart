import 'package:flutter_hello_world/model/car_model.dart';
import 'package:http/http.dart' as http;

class CarHttpService {
  final String _serverUrl = "https://car-data.p.rapidapi.com";
  final String _headerKey =
      "42f04f84e4msh0fd606ac38de8ffp12972fjsnc3540cc0aef6";
  final String _headerHost = "car-data.p.rapidapi.com";

  Future<List<CarsModel>> getCars() async {
    var uri = Uri.parse("$_serverUrl/cars");
    var response = await http.get(uri, headers: {
      "x-rapidapi-key": _headerKey,
      "x-rapidapi-host": _headerHost,
    });

    if (response.statusCode == 200) {
      return carsModelFromJson(response.body);
    } else {
      throw ("Error al obtenir la llista de cotxes: ${response.statusCode}");
    }
  }
}
