import 'package:flutter/material.dart';
import 'package:flutter_hello_world/model/car_model.dart';
import 'package:flutter_hello_world/services/car_http_service.dart';

class CarProvider extends ChangeNotifier {
  List<CarsModel> _cars = [];
  bool _isLoading = false;
  String _error = '';

  List<CarsModel> get cars => _cars;
  bool get isLoading => _isLoading;
  String get error => _error;

  final CarHttpService _carService = CarHttpService();

  Future<void> loadCars() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _cars = await _carService.getCars();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
