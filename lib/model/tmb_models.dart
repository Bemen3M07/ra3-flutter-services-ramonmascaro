import 'dart:convert';

// Model per a una línia de bus
class BusLine {
  BusLine({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.origin,
    required this.destination,
    required this.color,
  });

  final int id;
  final int code;
  final String name;
  final String description;
  final String origin;
  final String destination;
  final String color;

  factory BusLine.fromMap(Map<String, dynamic> json) => BusLine(
        id: json["ID_LINIA"] ?? 0,
        code: json["CODI_LINIA"] ?? 0,
        name: json["NOM_LINIA"] ?? '',
        description: json["DESC_LINIA"] ?? '',
        origin: json["ORIGEN_LINIA"] ?? '',
        destination: json["DESTI_LINIA"] ?? '',
        color: json["COLOR_LINIA"] ?? 'CCCCCC',
      );
}

// Model per a una parada de bus
class BusStop {
  BusStop({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.address,
    required this.district,
  });

  final int id;
  final int code;
  final String name;
  final String description;
  final String address;
  final String district;

  factory BusStop.fromMap(Map<String, dynamic> json) => BusStop(
        id: json["ID_PARADA"] ?? 0,
        code: json["CODI_PARADA"] ?? 0,
        name: json["NOM_PARADA"] ?? '',
        description: json["DESC_PARADA"] ?? '',
        address: json["ADRECA"] ?? '',
        district: json["NOM_DISTRICTE"] ?? '',
      );
}

// Model per a l'iBus (temps d'espera d'un bus a una parada)
class IbusArrival {
  IbusArrival({
    required this.line,
    required this.destination,
    required this.timeInMin,
    required this.timeText,
  });

  final String line;
  final String destination;
  final int timeInMin;
  final String timeText;

  factory IbusArrival.fromMap(Map<String, dynamic> json) => IbusArrival(
        line: json["line"]?.toString() ?? '',
        destination: json["destination"]?.toString() ?? '',
        timeInMin: json["t-in-min"] ?? 0,
        timeText: json["text-ca"]?.toString() ?? '',
      );
}

// Funcions per parsejar les respostes GeoJSON de TMB
List<BusLine> busLinesFromJson(String str) {
  final data = json.decode(str);
  final features = data["features"] as List;
  return features.map((f) => BusLine.fromMap(f["properties"])).toList();
}

List<BusStop> busStopsFromJson(String str) {
  final data = json.decode(str);
  final features = data["features"] as List;
  return features.map((f) => BusStop.fromMap(f["properties"])).toList();
}

List<IbusArrival> ibusFromJson(String str) {
  final data = json.decode(str);
  final ibus = data["data"]?["ibus"] as List? ?? [];
  return ibus.map((i) => IbusArrival.fromMap(i)).toList();
}
