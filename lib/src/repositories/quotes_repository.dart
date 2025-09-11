import '../models/quote.dart';
import '../services/quote_api_service.dart';
import '../services/local_quotes_service.dart';
import '../services/firebase_service.dart';
import 'dart:math';

class QuotesRepository {
  final QuoteApiService apiService;
  final LocalQuotesService localService;
  final FirebaseService firebaseService;

  QuotesRepository({
    required this.apiService, 
    required this.localService,
    required this.firebaseService,
  });

  Future<Quote> getRandomQuote({bool preferApi = true}) async {
    if (preferApi) {
      try {
        return await apiService.fetchRandomQuote();
      } catch (_) {
        // fall back to local
      }
    }
    final all = localService.getAll();
    final rnd = Random();
    return all[rnd.nextInt(all.length)];
  }

  Future<List<Quote>> getBatch({bool preferApi = true}) async {
    if (preferApi) {
      try {
        return await apiService.fetchQuotes();
      } catch (_) {}
    }
    return localService.getAll();
  }

  // Firebase methods
  Future<void> saveQuoteToCloud(Quote quote) async {
    if (!firebaseService.isCloudEnabled) return;
    try {
      await firebaseService.saveQuoteToFirestore(quote);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Quote>> getQuotesFromCloud() async {
    if (!firebaseService.isCloudEnabled) {
      return localService.getAll();
    }
    try {
      return await firebaseService.getQuotesFromFirestore();
    } catch (e) {
      return localService.getAll();
    }
  }

  Future<void> saveFavoriteToCloud(Quote quote) async {
    if (!firebaseService.isCloudEnabled) return;
    try {
      await firebaseService.saveFavoriteToFirestore(quote);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFavoriteFromCloud(String quoteId) async {
    if (!firebaseService.isCloudEnabled) return;
    try {
      await firebaseService.removeFavoriteFromFirestore(quoteId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Quote>> getFavoritesFromCloud() async {
    if (!firebaseService.isCloudEnabled) return [];
    try {
      return await firebaseService.getFavoritesFromFirestore();
    } catch (e) {
      return [];
    }
  }
}


