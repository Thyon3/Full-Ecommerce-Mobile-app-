import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteProvider = ChangeNotifierProvider<FavouriteProvider>((ref) {
  return FavouriteProvider();
});

class FavouriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _favouriteIds = [];
  StreamSubscription? _favouritesSubscription;
  StreamSubscription? _authSubscription;

  List<String> get favourites => _favouriteIds;

  FavouriteProvider() {
    _setupAuthListener();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _favouritesSubscription?.cancel();
    super.dispose();
  }

  // Current user ID with null check
  String get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  // Set up auth state listener
  void _setupAuthListener() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToFavourites(user.uid);
      } else {
        _clearFavourites();
      }
    });
  }

  // Subscribe to real-time favourites updates
  void _subscribeToFavourites(String userId) {
    _favouritesSubscription?.cancel();
    _favouritesSubscription = _firestore
        .collection('userFavourite')
        .doc(userId)
        .collection('favourites')
        .snapshots()
        .listen((snapshot) {
          _favouriteIds = snapshot.docs.map((doc) => doc.id).toList();
          notifyListeners();
        }, onError: (e) => debugPrint('Favourites error: $e'));
  }

  // Clear favourites when user logs out
  void _clearFavourites() {
    _favouriteIds = [];
    notifyListeners();
  }

  // Toggle favourite status
  Future<void> toggleFavourite(DocumentSnapshot product) async {
    final productId = product.id;
    try {
      if (isFavourite(productId)) {
        await _removeFavourite(productId);
        _favouriteIds.remove(productId);
      } else {
        await _addFavourite(productId);
        _favouriteIds.add(productId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Toggle favourite error: $e');
      rethrow;
    }
  }

  // Check if product is favourite
  bool isFavourite(String productId) => _favouriteIds.contains(productId);

  // Add to Firestore
  Future<void> _addFavourite(String productId) async {
    await _firestore
        .collection('userFavourite')
        .doc(currentUserId)
        .collection('favourites')
        .doc(productId)
        .set({
          'isFavourite': true,
          'userId': currentUserId,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  // Remove from Firestore
  Future<void> _removeFavourite(String productId) async {
    await _firestore
        .collection('userFavourite')
        .doc(currentUserId)
        .collection('favourites')
        .doc(productId)
        .delete();
  }

  // Reset all favourites
  void reset() {
    _favouriteIds = [];
    notifyListeners();
  }

  // check whether a product is a favourite or not
  bool isExist(DocumentSnapshot product) {
    final productId = product.id;
    return _favouriteIds.contains(productId);
  }
}
