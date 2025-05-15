import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/cart_model.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/screen/item_details_screen/Screen/item_details.dart';

class CartItem extends StatelessWidget {
  final List<CartModel> cart;

  const CartItem({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final finalItem = cart[index];
          return GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40, top: 20, right: 20),
                  height: size.height * 0.13,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(153, 248, 242, 242),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
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
                      Padding(
                        padding: EdgeInsets.only(right: 30, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              finalItem.productData['name'],
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
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
