import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:thyecommercemobileapp/components/my_elevated_button.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class ItemDetails extends StatefulWidget {
  final Map<String, dynamic> appModel; //accepting the
  ItemDetails({super.key, required this.appModel});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  // int _selectedColorIndex = 1;
  // int _selectedSizeIndex = 1;
  int currentIndex = 0;

  double _getFontSize(String sizeText) {
    return switch (sizeText.length) {
      1 => 20, // For single chars like "S", "M"
      2 => 18, // For "XL"
      _ => 16, // For longer sizes like "XXL"
    };
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: SizedBox(),
        ),
        title: Text(
          "Product Details",
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Stack(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
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
                      '4',
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
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 30,
                    right: 20,
                    left: 20,
                    bottom: 30,
                  ),
                  height: size.height * 0.5,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(40, 228, 228, 235),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: widget.appModel['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
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
                    ],
                  ),
                  Text(
                    widget.appModel['name'],
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${widget.appModel['price'].toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (widget.appModel['isDiscounted'])
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '\$${(widget.appModel['price'] + 200).toStringAsFixed(2)}',
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
                  SizedBox(height: 20),
                  SizedBox(height: 30),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: size.width / 2.1,
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Color",
                  //             style: GoogleFonts.lato(
                  //               textStyle: TextStyle(
                  //                 color: Theme.of(context).colorScheme.primary,
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.w800,
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(height: 10),
                  //           Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               SingleChildScrollView(
                  //                 scrollDirection: Axis.horizontal,
                  //                 child: Row(
                  //                   children:
                  //                       (widget.appModel['colors'] as List).map<
                  //                         Widget
                  //                       >((color) {
                  //                         final index = (widget
                  //                                     .appModel['colors']
                  //                                 as List)
                  //                             .indexOf(color);
                  //                         return Padding(
                  //                           padding: EdgeInsets.only(
                  //                             top: 10,
                  //                             right: 10,
                  //                           ),
                  //                           child: CircleAvatar(
                  //                             radius: 23,
                  //                             backgroundColor:
                  //                                 color is int
                  //                                     ? Color(color)
                  //                                     : Colors.amber,
                  //                             child: InkWell(
                  //                               onTap: () {
                  //                                 setState(() {
                  //                                   _selectedColorIndex = index;
                  //                                 });
                  //                               },
                  //                               child: Icon(
                  //                                 Icons.check,
                  //                                 color:
                  //                                     _selectedColorIndex ==
                  //                                             index
                  //                                         ? Colors.white
                  //                                         : Colors.transparent,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         );
                  //                       }).toList(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: size.width / 2.1,
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Sizes",
                  //             style: GoogleFonts.lato(
                  //               textStyle: TextStyle(
                  //                 color: Theme.of(context).colorScheme.primary,
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.w800,
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(height: 10),
                  //           SingleChildScrollView(
                  //             scrollDirection: Axis.horizontal,
                  //             child: Row(
                  //               children:
                  //                   (widget.appModel['size'] as List).map<
                  //                     Widget
                  //                   >((size) {
                  //                     final index = (widget.appModel['size']
                  //                             as List)
                  //                         .indexOf(size);
                  //                     return InkWell(
                  //                       onTap:
                  //                           () => setState(
                  //                             () => _selectedSizeIndex = index,
                  //                           ),
                  //                       customBorder: CircleBorder(),
                  //                       child: Container(
                  //                         margin: EdgeInsets.only(right: 8),
                  //                         width: 48,
                  //                         height: 48,
                  //                         alignment: Alignment.center,
                  //                         decoration: BoxDecoration(
                  //                           shape: BoxShape.circle,
                  //                           color:
                  //                               _selectedSizeIndex == index
                  //                                   ? Colors.black
                  //                                   : Colors.grey[300],
                  //                         ),
                  //                         child: Text(
                  //                           size.toString(),
                  //                           style: GoogleFonts.lato(
                  //                             textStyle: TextStyle(
                  //                               color:
                  //                                   _selectedSizeIndex == index
                  //                                       ? Colors.white
                  //                                       : Colors.black,
                  //                               fontSize: _getFontSize(
                  //                                 size.toString(),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: size.width * 0.89,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Iconsax.shopping_cart,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        'ADD TO CART',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Iconsax.shopping_bag,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        backgroundColor: const Color.fromARGB(255, 29, 102, 32),
                      ),
                      label: Text(
                        'SHOP NOW',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }
}
