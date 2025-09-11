import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'src/app.dart';
import 'src/providers/theme_provider.dart';
import 'src/providers/favorites_provider.dart';
import 'src/providers/quotes_provider.dart';
import 'src/providers/auth_provider.dart';
import 'src/repositories/quotes_repository.dart';
import 'src/services/local_quotes_service.dart';
import 'src/services/quote_api_service.dart';
import 'src/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  runApp(const InspireMeBootstrap());
}

class InspireMeBootstrap extends StatelessWidget {
  const InspireMeBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final repository = QuotesRepository(
              apiService: QuoteApiService(),
              localService: LocalQuotesService(),
              firebaseService: FirebaseService(enableCloudFeatures: false),
            );
            final favoritesProvider = FavoritesProvider();
            favoritesProvider.setRepository(repository);
            return favoritesProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => QuotesProvider(
            repository: QuotesRepository(
              apiService: QuoteApiService(),
              localService: LocalQuotesService(),
              firebaseService: FirebaseService(enableCloudFeatures: false),
            ),
          ),
        ),
      ],
      child: const InspireMeApp(),
    );
  }
}
