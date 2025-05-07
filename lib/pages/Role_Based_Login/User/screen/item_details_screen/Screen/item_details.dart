import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:thyecommercemobileapp/components/my_elevated_button.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class ItemDetails extends StatefulWidget {
  final AppModel appModel;
  ItemDetails({super.key, required this.appModel});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  //

  int _selectedColorIndex = 1;
  int _selectedSizeIndex = 1;
  int currentIndex = 0;

  // get font size
  double _getFontSize(String sizeText) {
    return switch (sizeText.length) {
      1 => 20, // For single chars like "S", "M"
      2 => 18, // For "XL"
      _ => 16, // For longer sizes like "XXL"
    };
  }

  Widget build(context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20), // Space height
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
                      '4', //later we will make it dynamic based on teh number of orders recived
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
                    child: Image.asset(
                      widget.appModel.image,
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

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.blue, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            (widget.appModel.rating / widget.appModel.review)
                                .toStringAsFixed(2),
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${widget.appModel.rating.toInt()})',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    widget.appModel.name,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  // Price (always visible at bottom)
                  Row(
                    children: [
                      Text(
                        '\$${widget.appModel.price.toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (widget.appModel.isCheck)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '\$${(widget.appModel.price + 200).toStringAsFixed(2)}',
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

                  Text(
                    widget.appModel.description,
                    softWrap: true,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 2.1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Color",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children:
                                        widget.appModel.fcolor.asMap().entries.map((
                                          entry,
                                        ) {
                                          // have the current color and the current index by using the entries.value and enties.index propeties

                                          final color = entry.value;
                                          final index = entry.key;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: 10,
                                              right: 10,
                                            ),
                                            child: CircleAvatar(
                                              radius: 23,
                                              backgroundColor: color,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedColorIndex = index;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.check,
                                                  color:
                                                      _selectedColorIndex ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width / 2.1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sizes",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    widget.appModel.size.asMap().entries.map((
                                      entry,
                                    ) {
                                      String size = entry.value;
                                      int index = entry.key;

                                      return InkWell(
                                        onTap:
                                            () => setState(
                                              () => _selectedSizeIndex = index,
                                            ),
                                        customBorder: CircleBorder(),
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8),
                                          width: 48, // Fixed diameter
                                          height: 48, // Fixed diameter
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                _selectedSizeIndex == index
                                                    ? Colors.black
                                                    : Colors.grey[300],
                                          ),
                                          child: Text(
                                            size,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                color:
                                                    _selectedSizeIndex == index
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontSize: _getFontSize(
                                                  size,
                                                ), // Dynamic font sizing
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
