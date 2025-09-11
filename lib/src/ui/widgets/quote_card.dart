import 'package:flutter/material.dart';
import '../../models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final VoidCallback? onShare;

  const QuoteCard({super.key, required this.quote, this.onFavorite, this.isFavorite = false, this.onShare});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '“${quote.text}”',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              '- ${quote.author}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: onFavorite,
                ),
                const SizedBox(width: 8),
                if (onShare != null)
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: onShare,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


