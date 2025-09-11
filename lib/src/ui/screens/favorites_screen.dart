import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../widgets/quote_card.dart';

class FavoritesScreen extends StatelessWidget {
  static const String routeName = '/favorites';
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<FavoritesProvider>(
        builder: (_, favs, __) {
          final items = favs.favorites;
          if (items.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final q = items[i];
              return QuoteCard(
                quote: q,
                isFavorite: true,
                onFavorite: () => favs.toggle(q),
              );
            },
          );
        },
      ),
    );
  }
}


