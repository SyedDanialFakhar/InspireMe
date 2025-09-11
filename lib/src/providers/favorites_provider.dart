import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/quote.dart';
import '../repositories/quotes_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _key = 'favorites';
  final Map<String, Quote> _favorites = {};
  QuotesRepository? _repository;

  FavoritesProvider() {
    _load();
  }

  void setRepository(QuotesRepository repository) {
    _repository = repository;
  }

  List<Quote> get favorites => _favorites.values.toList(growable: false);
  bool isFavorite(String id) => _favorites.containsKey(id);

  Future<void> toggle(Quote quote) async {
    if (_favorites.containsKey(quote.id)) {
      _favorites.remove(quote.id);
      // Remove from Firebase if user is authenticated
      if (_repository != null) {
        try {
          await _repository!.removeFavoriteFromCloud(quote.id);
        } catch (e) {
          // Handle error silently
        }
      }
    } else {
      _favorites[quote.id] = quote;
      // Save to Firebase if user is authenticated
      if (_repository != null) {
        try {
          await _repository!.saveFavoriteToCloud(quote);
        } catch (e) {
          // Handle error silently
        }
      }
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final List list = json.decode(raw) as List;
      for (final item in list) {
        final map = Map<String, dynamic>.from(item as Map);
        final q = Quote(text: map['text'] as String, author: map['author'] as String, id: map['id'] as String);
        _favorites[q.id] = q;
      }
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(_favorites.values.map((e) => e.toJson()).toList()));
  }

  // Sync favorites from Firebase
  Future<void> syncFromFirebase() async {
    if (_repository == null) return;
    
    try {
      final cloudFavorites = await _repository!.getFavoritesFromCloud();
      _favorites.clear();
      
      for (final quote in cloudFavorites) {
        _favorites[quote.id] = quote;
      }
      
      notifyListeners();
      await _persist();
    } catch (e) {
      // Handle error silently
    }
  }
}


