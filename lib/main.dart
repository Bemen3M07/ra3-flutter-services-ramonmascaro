import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/providers/car_provider.dart';
import 'package:flutter_hello_world/providers/joke_provider.dart';
import 'package:flutter_hello_world/screens/jokes_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => JokeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P5d APIs i Serveis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Pantalla principal amb navegació als exercicis
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('P5d APIs i Serveis'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Exercici 2: Car Data (ListView)'),
            subtitle: const Text('Llista de cotxes amb Provider'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarsListScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.emoji_emotions),
            title: const Text('Exercici 3: Acudits'),
            subtitle: const Text('Acudit aleatori amb MVC'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JokesScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

// Exercici 2: Pantalla de llista de cotxes
class CarsListScreen extends StatefulWidget {
  const CarsListScreen({super.key});

  @override
  State<CarsListScreen> createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  @override
  void initState() {
    super.initState();
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
