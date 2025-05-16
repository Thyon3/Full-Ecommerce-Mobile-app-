import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/cart_model.dart';
import 'package:flutter/material.dart';

final cartProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});

class CartProvider extends ChangeNotifier {
  // first have an empty list of the cartModel
  List<CartModel> _cart = [];

  // set a getter to for the _cart

  List<CartModel> get getCart => _cart;

  // set a setter for th _cart

  set setCart(List<CartModel> cart) {
    _cart = cart;
    notifyListeners();
  }

  /*
  this does not update the userId as the user signs out and login again so use a getter 
  final userId = FirebaseAuth.instance.currentUser?.uid;
  */

  // so instead of finding directly the userId use a getter to return the userId
  String? get getUserId {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'please login first';
    }
    return user.uid;
  }

  void resetCart() {
    _cart = [];
    notifyListeners();
  }

  // load the _cart on the consutructor

  CartProvider() {
    final userId = getUserId;
    if (userId != null) {
      loadCartItemsFromFirestore();
    }
  }

  // add to cart funciton

  Future<void> addToCart(
    String productId,
    Map<String, dynamic> productData,
    String selectedColor,
    String selectdSize,
  ) async {
    // first find whether the selected item exist in the cart or not

    int index = _cart.indexWhere((cartItem) => cartItem.productId == productId);

    if (index != -1) {
      // the item already exits in the cart so update the quantity by one
      final existingItem = _cart[index];

      //use the copytwith to update the quantity of _cart[index]
      _cart[index] = existingItem.copywith(quantity: _cart[index].quantity + 1);

      // update on firestore

      await updateCartOnFirestore(productId, _cart[index].quantity);
    } else {
      // if the item doesnot exist add a new entry
      _cart.add(
        CartModel(
          productData: productData,
          productId: productId,
          selectdSize: selectdSize,
          selectedColor: selectedColor,
          quantity: 1,
        ),
      );

      // create a collection on firestore and add the items (for each user have a collection where the user can store his cart items on their product id )

      await FirebaseFirestore.instance
          .collection('UserCart')
          .doc(getUserId)
          .collection('UserCartItems')
          .doc(productId)
          .set({
            'productData': productData,
            'productId': productId,
            'selectedSize': selectdSize,
            'selectedColor': selectedColor,
            'quantity': 1,
          });
    }
    notifyListeners();
  }

  // add quantity

  Future<void> addQuantity(String productId) async {
    int index = _cart.indexWhere((cartItem) => cartItem.productId == productId);
    _cart[index].quantity++;

    // now call the upadateCartOnFirestore method to actually update the quantity on firbase

    await updateCartOnFirestore(productId, _cart[index].quantity);
    notifyListeners();
  }

  // decrease Quantity
  Future<void> decreaseQuantity(String productId) async {
    int index = _cart.indexWhere((cartItem) => cartItem.productId == productId);
    _cart[index].quantity--;

    if (_cart[index].quantity <= 0) {
      _cart.removeAt(index); // remove the item
      // also remove the itme from firstore
      await FirebaseFirestore.instance
          .collection('UserCart')
          .doc(getUserId)
          .collection('UserCartItems')
          .doc(productId)
          .delete();
    } else {
      await updateCartOnFirestore(productId, _cart[index].quantity);
    }
    notifyListeners();
  }

  // update the cartItems on firestore
  Future<void> updateCartOnFirestore(String productId, int quantity) async {
    // now update the quantity
    try {
      await FirebaseFirestore.instance
          .collection('UserCart')
          .doc(getUserId)
          .collection('UserCartItems')
          .doc(productId)
          .update({'qunatity': quantity});
    } catch (e) {
      throw Exception(e);
    }
    notifyListeners();
  }

  // check whether a product exists in the cart or not

  bool isExist(String productId) {
    return _cart.any((cartItem) => cartItem.productId == productId);
  }

  // calculate the total price of the cart

  double totalPrice() {
    double itemsTotalPrice = 0;

    for (int i = 0; i < _cart.length; i++) {
      itemsTotalPrice =
          itemsTotalPrice + (_cart[i].productData['price'] * _cart[i].quantity);
    }
    return itemsTotalPrice;
  }

  // load the cart items from firestore and assign to _cart

  Future<void> loadCartItemsFromFirestore() async {
    try {
      QuerySnapshot cartSnapshot =
          await FirebaseFirestore.instance
              .collection('UserCart')
              .doc(getUserId)
              .collection('UserCartItems')
              .get();

      _cart =
          cartSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CartModel(
              productData: data['productData'],
              productId: data['productId'] as String,
              selectdSize: data['selectedSize'] as String,
              selectedColor: data['selectedColor'] as String,
              quantity:
                  (data['quantity'] is int)
                      ? data['quantity'] as int
                      : int.tryParse(data['quantity'].toString()) ?? 1,
            );
          }).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  //remove selected item from firestore and also the _cart List

  Future<void> removeItemFromCart(String productId) async {
    int index = _cart.indexWhere((cartItem) => cartItem.productId == productId);
    if (index != -1) {
      _cart.removeAt(index);

      // also remove from firestore
      await FirebaseFirestore.instance
          .collection('UserCart')
          .doc(getUserId)
          .collection('UserCartItems')
          .doc(productId)
          .delete();
    }
    notifyListeners();
  }
}
