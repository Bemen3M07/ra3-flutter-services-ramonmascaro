import 'package:flutter/material.dart';
import 'package:flutter_hello_world/model/tmb_models.dart';
import 'package:flutter_hello_world/services/tmb_service.dart';

class TmbProvider extends ChangeNotifier {
  List<BusLine> _busLines = [];
  List<BusStop> _busStops = [];
  List<IbusArrival> _ibusArrivals = [];
  bool _isLoading = false;
  String _error = '';
  String _ibusStopName = '';

  List<BusLine> get busLines => _busLines;
  List<BusStop> get busStops => _busStops;
  List<IbusArrival> get ibusArrivals => _ibusArrivals;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get ibusStopName => _ibusStopName;

  final TmbService _tmbService = TmbService();

  // Endpoint 1: Carregar línies de bus
  Future<void> loadBusLines() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _busLines = await _tmbService.getBusLines();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Endpoint 2: Carregar parades de bus
  Future<void> loadBusStops() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _busStops = await _tmbService.getBusStops();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Endpoint 3: Consultar iBus per codi de parada
  Future<void> searchIbus(int stopCode) async {
    _isLoading = true;
    _error = '';
    _ibusArrivals = [];
    _ibusStopName = 'Parada $stopCode';
    notifyListeners();

    try {
      _ibusArrivals = await _tmbService.getIbus(stopCode);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
