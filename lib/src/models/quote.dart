class Quote {
  final String text;
  final String author;
  final String id;

  const Quote({required this.text, required this.author, required this.id});

  factory Quote.fromZen(Map<String, dynamic> json) {
    // ZenQuotes: [{q: text, a: author, h: html}]
    return Quote(
      text: (json['q'] as String?)?.trim() ?? '',
      author: (json['a'] as String?)?.trim().isNotEmpty == true ? (json['a'] as String).trim() : 'Unknown',
      id: '${json['q']}_${json['a']}'.hashCode.toString(),
    );
  }

  Map<String, dynamic> toJson() => { 'id': id, 'text': text, 'author': author };
}


