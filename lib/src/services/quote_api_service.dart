import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteApiService {
  static const String _base = 'https://zenquotes.io/api';

  Future<Quote> fetchRandomQuote() async {
    final uri = Uri.parse('$_base/random');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body) as List;
      if (data.isNotEmpty) {
        return Quote.fromZen(Map<String, dynamic>.from(data.first as Map));
      }
    }
    throw Exception('Failed to load quote');
  }

  Future<List<Quote>> fetchQuotes({int limit = 50}) async {
    final uri = Uri.parse('$_base/quotes');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body) as List;
      return data.map((e) => Quote.fromZen(Map<String, dynamic>.from(e as Map))).toList();
    }
    throw Exception('Failed to load quotes');
  }
}


