import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteProvider = ChangeNotifierProvider<FavouriteProvider>((ref) {
  return FavouriteProvider();
});

class FavouriteProvider extends ChangeNotifier {
  List<String> favouriteIds = [];
  final _firestoreInstance = FirebaseFirestore.instance;

  // lets have a getter for the favourites
  List<String> get getFavourites {
    return favouriteIds;
  }

  // reset all the favourites

  void reset() {
    favouriteIds = [];
    notifyListeners();
  }

  // first get hte id of the current user

  final userId = FirebaseAuth.instance.currentUser!.uid;
  FavouriteProvider() {
    loadFavourites();
  }

  // toggle favourites

  void toggleFavourites(DocumentSnapshot product) async {
    final productId = product.id;

    //  if the product is already favourite remove it and if not add it to the favourite list
    if (favouriteIds.contains(productId)) {
      favouriteIds.remove(productId);

      // now rmove the productID from firestore
      await _removeFavouriteFromFirestore(productId);
    } else {
      (favouriteIds.add(productId));
      //  now add the productId to firestore
      await _addFavouriteToFirestore(productId);
    }

    notifyListeners();
  }

  // check whether the item is favourite or not

  bool isExist(DocumentSnapshot product) {
    return favouriteIds.contains(product.id);
  }
  //  add the favourite list items to firestore

  Future<void> _addFavouriteToFirestore(String ProductId) async {
    try {
      await _firestoreInstance.collection('userFavourite').doc(ProductId).set({
        'isFavourite': true,
        'UserId': userId,
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
  // remove the favourite item from firestore

  Future<void> _removeFavouriteFromFirestore(String ProductId) async {
    try {
      await _firestoreInstance
          .collection('userFavourite')
          .doc(ProductId)
          .delete();
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  // loading the favourite items form firestore when the app first runs

  Future<void> loadFavourites() async {
    try {
      QuerySnapshot snapshots =
          await _firestoreInstance
              .collection('userFavourite')
              .where('UserId', isEqualTo: userId)
              .get();

      favouriteIds =
          snapshots.docs.map((doc) {
            return doc.id;
          }).toList();

      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
}
