import 'package:flutter_hello_world/model/tmb_models.dart';
import 'package:http/http.dart' as http;

class TmbService {
  final String _baseUrl = "https://api.tmb.cat/v1";
  final String _appId = "479e85c8";
  final String _appKey = "dee99c20f3de7fa575b9fb8246ee7954";

  String _buildUrl(String endpoint) {
    return "$_baseUrl$endpoint?app_id=$_appId&app_key=$_appKey";
  }

  // Endpoint 1: Obtenir totes les línies de bus
  Future<List<BusLine>> getBusLines() async {
    var uri = Uri.parse(_buildUrl("/transit/linies/bus"));
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return busLinesFromJson(response.body);
    } else {
      throw ("Error al obtenir les línies: ${response.statusCode}");
    }
  }

  // Endpoint 2: Obtenir totes les parades de bus
  Future<List<BusStop>> getBusStops() async {
    var uri = Uri.parse(_buildUrl("/transit/parades"));
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return busStopsFromJson(response.body);
    } else {
      throw ("Error al obtenir les parades: ${response.statusCode}");
    }
  }

  // Endpoint 3: Obtenir els busos que passen per una parada (iBus)
  Future<List<IbusArrival>> getIbus(int stopCode) async {
    var uri = Uri.parse(_buildUrl("/ibus/stops/$stopCode"));
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return ibusFromJson(response.body);
    } else {
      throw ("Error al obtenir iBus: ${response.statusCode}");
    }
  }
}
