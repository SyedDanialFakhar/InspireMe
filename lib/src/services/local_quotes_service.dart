import '../models/quote.dart';

class LocalQuotesService {
  static const List<Map<String, String>> _local = [
    {'q': 'The best time to plant a tree was 20 years ago. The second best time is now.', 'a': 'Chinese Proverb'},
    {'q': 'Your limitation—it’s only your imagination.', 'a': 'Unknown'},
    {'q': 'Push yourself, because no one else is going to do it for you.', 'a': 'Unknown'},
    {'q': 'Sometimes later becomes never. Do it now.', 'a': 'Unknown'},
    {'q': 'Great things never come from comfort zones.', 'a': 'Unknown'},
    {'q': 'Dream it. Wish it. Do it.', 'a': 'Unknown'},
    {'q': 'Success doesn’t just find you. You have to go out and get it.', 'a': 'Unknown'},
    {'q': 'The harder you work for something, the greater you’ll feel when you achieve it.', 'a': 'Unknown'},
    {'q': 'Dream bigger. Do bigger.', 'a': 'Unknown'},
    {'q': 'Don’t stop when you’re tired. Stop when you’re done.', 'a': 'Unknown'},
    {'q': 'Wake up with determination. Go to bed with satisfaction.', 'a': 'Unknown'},
    {'q': 'Do something today that your future self will thank you for.', 'a': 'Unknown'},
    {'q': 'Little things make big days.', 'a': 'Unknown'},
    {'q': 'It’s going to be hard, but hard does not mean impossible.', 'a': 'Unknown'},
    {'q': 'Don’t wait for opportunity. Create it.', 'a': 'Unknown'},
    {'q': 'Sometimes we’re tested not to show our weaknesses, but to discover our strengths.', 'a': 'Unknown'},
    {'q': 'The key to success is to focus on goals, not obstacles.', 'a': 'Unknown'},
    {'q': 'Dream it. Believe it. Build it.', 'a': 'Unknown'},
    {'q': 'Believe you can and you’re halfway there.', 'a': 'Theodore Roosevelt'},
    {'q': 'It always seems impossible until it’s done.', 'a': 'Nelson Mandela'},
  ];

  List<Quote> getAll() {
    return _local
        .map((e) => Quote.fromZen({'q': e['q']!, 'a': e['a'] ?? 'Unknown'}))
        .toList();
  }
}


