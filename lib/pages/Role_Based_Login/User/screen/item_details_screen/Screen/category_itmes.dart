import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/category_model.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/sub_category.dart';

class CategoryItems extends StatelessWidget {
  final List<AppModel> appModel;
  final String category;
  const CategoryItems({
    super.key,
    required this.appModel,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Row
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "${category}'s Fashion",
                          hintStyle: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          prefixIcon: const Icon(Icons.search_outlined),
                          fillColor: const Color.fromARGB(255, 228, 219, 206),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Horizontal Scrollable Categories
            SizedBox(
              height: 50, // Fixed height for scrollable area
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: List.generate(filterCategory.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:
                            index == 0
                                ? Row(
                                  children: [
                                    Text(
                                      filterCategory[index],
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),

                                    Icon(Icons.filter_list, size: 15),
                                  ],
                                )
                                : Row(
                                  children: [
                                    Text(
                                      filterCategory[index],
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 15,
                                    ),
                                  ],
                                ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            SizedBox(height: 20),
            // the subcategory list goes here
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(subCategories.length, (index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding:
                          index == 0
                              ? EdgeInsets.only(left: 40, right: 20)
                              : EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color.fromARGB(
                              255,
                              192,
                              188,
                              188,
                            ),
                            backgroundImage: AssetImage(
                              subCategories[index].imagePath,
                            ),
                          ),
                          Text(
                            subCategories[index].name,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // now lets put the itmes in the selected category i mean their details in a two grid container
            SizedBox(height: 20),
            appModel.isEmpty
                ? Center(
                  child: Text(
                    'This category is empty ',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                : Padding(
                  padding: EdgeInsets.only(
                    top: 25,
                    bottom: 25,
                    right: 15,
                    left: 10,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 100,
                                crossAxisCount: 2,
                              ),
                          itemCount: appModel.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Container
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        40,
                                        228,
                                        228,
                                        235,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        appModel[index].image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Product Info
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Brand and Rating - Fixed to prevent merging
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                'H&M',
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${(appModel[index].rating / appModel[index].review).toStringAsFixed(1)}',
                                                    style: GoogleFonts.lato(
                                                      textStyle: const TextStyle(
                                                        color:
                                                            Colors
                                                                .deepOrangeAccent,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '(${appModel[index].rating.toInt()})',
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // Product Name - Fixed word separation
                                        Text(
                                          appModel[index].name.replaceAll(
                                            RegExp(r'([a-z])([A-Z])'),
                                            r'$1 $2',
                                          ), // Adds space between camelCase
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        // Price and Size - Properly separated
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${appModel[index].price.toStringAsFixed(2)}',
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      Colors.deepOrangeAccent,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '16M',
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '0.5',
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (appModel[index].isCheck)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: Text(
                                              '\$${(appModel[index].price + 200).toStringAsFixed(2)}',
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w800,
                                                  decoration:
                                                      TextDecoration
                                                          .lineThrough,
                                                ),
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
