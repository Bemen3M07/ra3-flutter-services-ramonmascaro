import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hello_world/services/car_http_service.dart';

void main() {
  group('CarsApi', () {
    test('get cars', () async {
      final carHttpService = CarHttpService();
      final cars = await carHttpService.getCars();

      print('Nombre de cotxes rebuts: ${cars.length}');
      print('---');
      for (var car in cars) {
        print('ID: ${car.id} | ${car.year} ${car.make} ${car.model} (${car.type})');
      }
      print('---');
      print('Primer cotxe ID: ${cars[0].id}');
      print('Últim cotxe ID: ${cars[9].id}');

      expect(cars.length, 10);
      expect(cars[0].id, 9582);
      expect(cars[9].id, 9591);
    });
  });
}
