import 'package:flutter_hello_world/model/car_model.dart';
import 'package:http/http.dart' as http;

class CarHttpService {
  final String _serverUrl = "https://car-data.p.rapidapi.com";
  final String _headerKey =
      "42f04f84e4msh0fd606ac38de8ffp12972fjsnc3540cc0aef6";
  final String _headerHost = "car-data.p.rapidapi.com";

  /*
    Obtenir la llista de cotxes
  */
  Future<List<CarsModel>> getCars() async {
    // URL de l'endpoint: És la URL del servidor, més la URL de l'endpoint
    var uri = Uri.parse("$_serverUrl/cars");

    // Fem la petició GET i esperem la resposta
    var response = await http.get(uri, headers: {
      "x-rapidapi-key": _headerKey,
      "x-rapidapi-host": _headerHost,
    });

    // Control d'errors. Si la resposta és 200, tot ha anat bé. Si nó, llancem un error
    if (response.statusCode == 200) {
      return carsModelFromJson(response.body);
    } else {
      throw ("Error al obtenir la llista de cotxes: ${response.statusCode}");
    }
  }
}
