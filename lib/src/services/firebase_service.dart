import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/quote.dart';

class FirebaseService {
  final bool enableCloudFeatures;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  FirebaseService({this.enableCloudFeatures = false});

  // Authentication methods
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await _analytics.logLogin(loginMethod: 'email');
      return credential;
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await _analytics.logSignUp(signUpMethod: 'email');
      return credential;
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _analytics.logEvent(name: 'user_signed_out');
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  // Firestore methods for quotes
  Future<void> saveQuoteToFirestore(Quote quote) async {
    if (!enableCloudFeatures) return; // No-op when cloud is disabled
    try {
      await _firestore.collection('quotes').doc(quote.id).set({
        'text': quote.text,
        'author': quote.author,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': currentUser?.uid,
      });
      
      await _analytics.logEvent(
        name: 'quote_saved_to_cloud',
        parameters: {'quote_id': quote.id},
      );
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  Future<List<Quote>> getQuotesFromFirestore() async {
    if (!enableCloudFeatures) return []; // No-op when cloud is disabled
    try {
      final snapshot = await _firestore
          .collection('quotes')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      final quotes = snapshot.docs.map((doc) {
        final data = doc.data();
        return Quote(
          id: doc.id,
          text: data['text'] ?? '',
          author: data['author'] ?? 'Unknown',
        );
      }).toList();

      await _analytics.logEvent(name: 'quotes_fetched_from_cloud');
      return quotes;
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  // Firestore methods for user favorites
  Future<void> saveFavoriteToFirestore(Quote quote) async {
    if (!enableCloudFeatures) return; // No-op when cloud is disabled
    if (currentUser == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('favorites')
          .doc(quote.id)
          .set({
        'text': quote.text,
        'author': quote.author,
        'savedAt': FieldValue.serverTimestamp(),
      });
      
      await _analytics.logEvent(
        name: 'favorite_saved_to_cloud',
        parameters: {'quote_id': quote.id},
      );
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  Future<void> removeFavoriteFromFirestore(String quoteId) async {
    if (!enableCloudFeatures) return; // No-op when cloud is disabled
    if (currentUser == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('favorites')
          .doc(quoteId)
          .delete();
      
      await _analytics.logEvent(
        name: 'favorite_removed_from_cloud',
        parameters: {'quote_id': quoteId},
      );
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  Future<List<Quote>> getFavoritesFromFirestore() async {
    if (!enableCloudFeatures) return []; // No-op when cloud is disabled
    if (currentUser == null) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('favorites')
          .orderBy('savedAt', descending: true)
          .get();

      final favorites = snapshot.docs.map((doc) {
        final data = doc.data();
        return Quote(
          id: doc.id,
          text: data['text'] ?? '',
          author: data['author'] ?? 'Unknown',
        );
      }).toList();

      await _analytics.logEvent(name: 'favorites_fetched_from_cloud');
      return favorites;
    } catch (e) {
      await _crashlytics.recordError(e, null, fatal: false);
      rethrow;
    }
  }

  // Analytics methods
  Future<void> logQuoteGenerated() async {
    await _analytics.logEvent(name: 'quote_generated');
  }

  Future<void> logQuoteShared(String quoteId) async {
    await _analytics.logEvent(
      name: 'quote_shared',
      parameters: {'quote_id': quoteId},
    );
  }

  Future<void> logThemeChanged(String theme) async {
    await _analytics.logEvent(
      name: 'theme_changed',
      parameters: {'theme': theme},
    );
  }

  // Crashlytics methods
  Future<void> recordError(dynamic exception, StackTrace? stackTrace, {bool fatal = false}) async {
    await _crashlytics.recordError(exception, stackTrace, fatal: fatal);
  }

  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  bool get isCloudEnabled => enableCloudFeatures;
}
