import 'package:supabase_flutter/supabase_flutter.dart';

class CartModel {
  final String productId;
  final Map<String, dynamic> productData;
  int quantity;
  final String selectedColor;
  final String selectdSize;

  CartModel({
    required this.productData,
    required this.productId,
    required this.selectdSize,
    required this.selectedColor,
    required this.quantity,
  });

  // sue copywith to copy elements with a little modification

  CartModel copywith({
    String? productId,
    Map<String, dynamic>? productData,
    int? quantity,
    String? selectedColor,
    String? selectdSize,
  }) {
    return CartModel(
      productData: productData ?? this.productData,
      productId: productId ?? this.productId,
      selectdSize: selectdSize ?? this.selectdSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }
}
