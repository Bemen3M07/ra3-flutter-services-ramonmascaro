import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/providers/car_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CarProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Data',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CarsListScreen(),
    );
  }
}

class CarsListScreen extends StatefulWidget {
  const CarsListScreen({super.key});

  @override
  State<CarsListScreen> createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  @override
  void initState() {
    super.initState();
    // Carreguem els cotxes quan s'inicia la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarProvider>().loadCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    final carProvider = context.watch<CarProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Car Data API'),
      ),
      body: _buildBody(carProvider),
    );
  }

  Widget _buildBody(CarProvider carProvider) {
    if (carProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (carProvider.error.isNotEmpty) {
      return Center(child: Text('Error: ${carProvider.error}'));
    }

    return ListView.builder(
      itemCount: carProvider.cars.length,
      itemBuilder: (context, index) {
        final car = carProvider.cars[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(car.id.toString()),
          ),
          title: Text('${car.make} ${car.model}'),
          subtitle: Text('Any: ${car.year} - Tipus: ${car.type}'),
        );
      },
    );
  }
}
