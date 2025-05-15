import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/controller/favourite_provider.dart';

class ItemModels extends ConsumerWidget {
  final DocumentSnapshot ecommerceItem;
  final Size size;

  const ItemModels({
    super.key,
    required this.ecommerceItem,
    required this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // access the favourite provider
    return SizedBox(
      width: size.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed height image container
          Container(
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 134, 155, 177),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CachedNetworkImageProvider(ecommerceItem['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Color.fromARGB(255, 250, 231, 231),
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(favouriteProvider)
                          .toggleFavourite(ecommerceItem);
                    },
                    child:
                        ref.read(favouriteProvider).isExist(ecommerceItem)
                            ? Icon(
                              Icons.favorite_outlined,
                              size: 30,
                              color: Colors.red,
                            )
                            : Icon(
                              Icons.favorite_outline,
                              size: 30,
                              color: Colors.red,
                            ),
                  ),
                ),
              ),
            ),
          ),

          // Scrollable content area
          Container(
            height: 110, // Fixed height for all cards
            padding: const EdgeInsets.only(top: 8),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // iOS-style scrolling
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sizes and Rating
                  SizedBox(
                    height: 30,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Sizes
                          Text(
                            'H&M',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // // Rating
                          // Row(
                          //   children: [
                          //     const Icon(
                          //       Icons.star,
                          //       color: Colors.blue,
                          //       size: 20,
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       'hi',
                          //       // (ecommerceItem['rating'] /
                          //       //         ecommerceItem['review'])
                          //       //     .toStringAsFixed(2),
                          //       style: GoogleFonts.lato(
                          //         textStyle: const TextStyle(
                          //           color: Colors.deepOrangeAccent,
                          //           fontWeight: FontWeight.w800,
                          //           fontSize: 16,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       '(${ecommerceItem['rating'].toInt()})',
                          //       style: GoogleFonts.lato(
                          //         textStyle: const TextStyle(
                          //           color: Colors.black45,
                          //           fontWeight: FontWeight.w800,
                          //           fontSize: 16,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Product Name - Fully visible through scrolling
                  Text(
                    ecommerceItem['name'],
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price (always visible at bottom)
                  Row(
                    children: [
                      Text(
                        '\$${ecommerceItem['price'].toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (ecommerceItem['isDiscounted'])
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '\$${(ecommerceItem['price'] + 200).toStringAsFixed(2)}',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.lineThrough,
                              ),
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
    );
  }
}
