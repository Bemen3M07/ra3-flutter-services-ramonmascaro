import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/providers/joke_provider.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JokeProvider>().loadRandomJoke();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jokeProvider = context.watch<JokeProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Acudits'),
      ),
      body: _buildBody(jokeProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: jokeProvider.isLoading
            ? null
            : () => jokeProvider.loadRandomJoke(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(JokeProvider jokeProvider) {
    if (jokeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (jokeProvider.error.isNotEmpty) {
      return Center(child: Text('Error: ${jokeProvider.error}'));
    }

    final joke = jokeProvider.currentJoke;
    if (joke == null) {
      return const Center(child: Text('Prem el botó per veure un acudit'));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    joke.setup,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    joke.punchline,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Chip(label: Text(joke.type)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
