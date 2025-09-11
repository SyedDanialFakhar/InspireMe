import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/quotes_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_service.dart';
import '../widgets/inspire_button.dart';
import '../widgets/quote_card.dart';
import 'favorites_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AudioPlayer _player;
  late final FirebaseService _firebaseService;
  bool _loadedOnce = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _firebaseService = FirebaseService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quotes = context.read<QuotesProvider>();
      if (quotes.current == null && !quotes.isLoading) {
        quotes.loadRandom();
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playChime() async {
    try {
      if (kIsWeb) return;
      await _player.play(AssetSource('sounds/chime.mp3'));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final quotes = context.watch<QuotesProvider>();
      final favs = context.watch<FavoritesProvider>();
      final themeProvider = context.watch<ThemeProvider>();

      return Scaffold(
          appBar: AppBar(
            title: const Text('InspireMe'),
            actions: [
              IconButton(
                icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () async {
                  final next = switch (themeProvider.themeMode) {
                    ThemeMode.dark => ThemeMode.light,
                    ThemeMode.light => ThemeMode.system,
                    _ => ThemeMode.dark,
                  };
                  themeProvider.setTheme(next);
                  
                  // Log theme change to analytics
                  await _firebaseService.logThemeChanged(next.name);
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.pushNamed(context, FavoritesScreen.routeName);
                },
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return IconButton(
                    icon: Icon(authProvider.isAuthenticated ? Icons.logout : Icons.login),
                    onPressed: () async {
                      if (authProvider.isAuthenticated) {
                        await authProvider.signOut();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AuthScreen()),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: 400.ms,
                      transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: SlideTransition(position: Tween(begin: const Offset(0, .03), end: Offset.zero).animate(anim), child: child)),
                      child: quotes.current == null
                          ? (quotes.isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Tap Inspire Me to begin'))
                          : Hero(
                              tag: quotes.current!.id,
                              child: QuoteCard(
                                key: ValueKey(quotes.current!.id),
                                quote: quotes.current!,
                                isFavorite: favs.isFavorite(quotes.current!.id),
                                onFavorite: () => favs.toggle(quotes.current!),
                                onShare: () async {
                                  Share.share('${quotes.current!.text} — ${quotes.current!.author}');
                                  // Log share event to analytics
                                  await _firebaseService.logQuoteShared(quotes.current!.id);
                                },
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: InspireButton(
                    loading: quotes.isLoading,
                    onPressed: () async {
                      await _playChime();
                      if (!quotes.isLoading) {
                        await quotes.loadRandom();
                        // Log quote generation to analytics
                        await _firebaseService.logQuoteGenerated();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (!quotes.isLoading) {
              await quotes.loadRandom();
              // Log quote generation to analytics
              await _firebaseService.logQuoteGenerated();
            }
          },
          child: const Icon(Icons.refresh),
        ),
      );
    });
  }
}


