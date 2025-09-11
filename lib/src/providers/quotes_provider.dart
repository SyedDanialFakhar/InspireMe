import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../repositories/quotes_repository.dart';

class QuotesProvider extends ChangeNotifier {
  final QuotesRepository repository;

  QuotesProvider({required this.repository});

  Quote? _current;
  bool _loading = false;
  String? _error;

  Quote? get current => _current;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> loadRandom() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _current = await repository.getRandomQuote();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}


