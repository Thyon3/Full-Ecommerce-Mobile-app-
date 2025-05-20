import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/controller/cart_provider.dart';

class CartItem extends ConsumerWidget {
  const CartItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch the cartProvider
    final cartState = ref.watch(cartProvider);
    final cart = cartState.getCart;

    // calculate the final pric of the total items in the cart

    return Expanded(
      child:
          cart.isEmpty
              ? Center(
                child: Text(
                  'Your cart is empty',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final finalItem = cart[index];
                  // calculate the total price for a single cart item
                  int cartItemFinalPrice =
                      finalItem.productData['price'] * finalItem.quantity;
                  return GestureDetector(
                    onTap: () {},
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 40, top: 20, right: 20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(153, 248, 242, 242),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      finalItem.productData['image'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 30, top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        finalItem.productData['name'],
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      // show the user hte selectd color and size of the cart item
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Color: ',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.secondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.black,
                                              ),
                                            ],
                                          ),
                                          // show the selected size of the selected cart item
                                          SizedBox(width: 15),
                                          Row(
                                            children: [
                                              Text(
                                                'Size: ${finalItem.selectdSize}',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.secondary,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 20),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                '\$${cartItemFinalPrice.toString()}',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              // a controller for the quantity
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      cartState.addQuantity(
                                                        finalItem.productId,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .tertiary,

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onTertiary,
                                                      ),
                                                    ),
                                                  ),

                                                  // show the quantity in the middle
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Text(
                                                      finalItem.quantity
                                                          .toString(),
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      cartState
                                                          .decreaseQuantity(
                                                            finalItem.productId,
                                                          );
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .tertiary,

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              9,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onTertiary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
