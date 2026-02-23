import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/providers/tmb_provider.dart';

class TmbScreen extends StatefulWidget {
  const TmbScreen({super.key});

  @override
  State<TmbScreen> createState() => _TmbScreenState();
}

class _TmbScreenState extends State<TmbScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TMB Barcelona'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.route), text: 'Línies'),
            Tab(icon: Icon(Icons.location_on), text: 'Parades'),
            Tab(icon: Icon(Icons.access_time), text: 'iBus'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BusLinesTab(),
          BusStopsTab(),
          IbusTab(),
        ],
      ),
    );
  }
}

// Tab 1: Línies de bus
class BusLinesTab extends StatefulWidget {
  const BusLinesTab({super.key});

  @override
  State<BusLinesTab> createState() => _BusLinesTabState();
}

class _BusLinesTabState extends State<BusLinesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TmbProvider>();
      if (provider.busLines.isEmpty) {
        provider.loadBusLines();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TmbProvider>();

    if (provider.isLoading && provider.busLines.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty && provider.busLines.isEmpty) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    return ListView.builder(
      itemCount: provider.busLines.length,
      itemBuilder: (context, index) {
        final line = provider.busLines[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _colorFromHex(line.color),
            child: Text(
              line.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          title: Text(line.description),
          subtitle: Text('${line.origin} - ${line.destination}'),
        );
      },
    );
  }
}

// Tab 2: Parades de bus
class BusStopsTab extends StatefulWidget {
  const BusStopsTab({super.key});

  @override
  State<BusStopsTab> createState() => _BusStopsTabState();
}

class _BusStopsTabState extends State<BusStopsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TmbProvider>();
      if (provider.busStops.isEmpty) {
        provider.loadBusStops();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TmbProvider>();

    if (provider.isLoading && provider.busStops.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty && provider.busStops.isEmpty) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    return ListView.builder(
      itemCount: provider.busStops.length,
      itemBuilder: (context, index) {
        final stop = provider.busStops[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(stop.code.toString()),
          ),
          title: Text(stop.name),
          subtitle: Text('${stop.address} - ${stop.district}'),
        );
      },
    );
  }
}

// Tab 3: iBus - Consultar parada per codi
class IbusTab extends StatefulWidget {
  const IbusTab({super.key});

  @override
  State<IbusTab> createState() => _IbusTabState();
}

class _IbusTabState extends State<IbusTab> {
  final TextEditingController _stopController = TextEditingController();

  @override
  void dispose() {
    _stopController.dispose();
    super.dispose();
  }

  void _search() {
    final code = int.tryParse(_stopController.text);
    if (code != null) {
      context.read<TmbProvider>().searchIbus(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TmbProvider>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stopController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Codi de parada',
                    hintText: 'Ex: 2855',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _search,
                child: const Text('Cercar'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildIbusResults(provider),
        ),
      ],
    );
  }

  Widget _buildIbusResults(TmbProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    if (provider.ibusArrivals.isEmpty && provider.ibusStopName.isNotEmpty) {
      return Center(
        child: Text(
          'No hi ha busos propers a ${provider.ibusStopName}',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    if (provider.ibusArrivals.isEmpty) {
      return const Center(
        child: Text(
          'Introdueix un codi de parada per consultar els busos',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            provider.ibusStopName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: provider.ibusArrivals.length,
            itemBuilder: (context, index) {
              final arrival = provider.ibusArrivals[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    arrival.line,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(arrival.destination),
                trailing: Text(
                  arrival.timeText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Color _colorFromHex(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
