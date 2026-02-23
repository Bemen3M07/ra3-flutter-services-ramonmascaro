import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/model/joke_model.dart';
import 'package:flutter_hello_world/services/joke_service.dart';

class JokeProvider extends ChangeNotifier {
  JokeModel? _currentJoke;
  List<JokeModel> _jokes = [];
  bool _isLoading = false;
  String _error = '';

  JokeModel? get currentJoke => _currentJoke;
  bool get isLoading => _isLoading;
  String get error => _error;

  final JokeService _jokeService = JokeService();
  final Random _random = Random();

  Future<void> loadRandomJoke() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (_jokes.isEmpty) {
        _jokes = await _jokeService.getJokes();
      }
      _currentJoke = _jokes[_random.nextInt(_jokes.length)];
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
