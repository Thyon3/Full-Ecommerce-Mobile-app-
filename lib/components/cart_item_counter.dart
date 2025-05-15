import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/controller/cart_provider.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_activity/add_to_cart/screen/cart_screen.dart';

class CartItemCounter extends ConsumerStatefulWidget {
  const CartItemCounter({super.key});

  @override
  ConsumerState<CartItemCounter> createState() => _CartItemCounterState();
}

class _CartItemCounterState extends ConsumerState<CartItemCounter> {
  @override
  Widget build(BuildContext context) {
    int cartItemsNumber = ref.watch(cartProvider).getCart.length;
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (contex) => CartScreen()),
            );
          },
          child: Icon(Icons.shopping_bag, size: 40, color: Colors.black),
        ),
        Positioned(
          top: -3,
          left: -1,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Text(
              cartItemsNumber
                  .toString(), //later we will make it dynamic based on teh number of orders recived
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
