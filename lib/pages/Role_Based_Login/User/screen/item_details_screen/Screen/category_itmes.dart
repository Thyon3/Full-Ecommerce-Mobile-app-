import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/category_model.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/sub_category.dart';

class CategoryItems extends StatefulWidget {
  // this screen accepts the name of the category selected and the items inside of that category in a list
  // final List<AppModel> appModel;   now i don't need this i only need the selected category
  final String selectedCategory;
  const CategoryItems({super.key, required this.selectedCategory});

  @override
  State<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  // lets have some declaration some empty lists we can use to filter the whole items

  List<QueryDocumentSnapshot> allItems = [];
  List<QueryDocumentSnapshot> filterdItems = [];

  TextEditingController searchController = TextEditingController();
  void onSearchChanged() {
    // suggesting

    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      filterdItems =
          allItems.where((item) {
            final data = item.data() as Map<String, dynamic>;
            final itemName = data['name'].toString().toLowerCase();
            return itemName.contains(searchTerm);
          }).toList();
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    CollectionReference itemsList = FirebaseFirestore.instance.collection(
      'items',
    );

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
                        controller: searchController,
                        onSubmitted: (context) {
                          onSearchChanged();
                        },
                        decoration: InputDecoration(
                          hintText: "${widget.selectedCategory}'s Fashion",
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
            filterdItems.isEmpty
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
                : Expanded(
                  child: StreamBuilder(
                    stream:
                        itemsList
                            .where(
                              'category',
                              isEqualTo: widget.selectedCategory,
                            )
                            .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                      if (snapshots.hasData) {
                        final items = snapshots.data!.docs;
                        if (allItems.isEmpty) {
                          allItems = items;
                          filterdItems = items;
                        }
                        if (filterdItems.isEmpty) {
                          return Center(child: Text('No Items are found'));
                        }

                        return GridView.builder(
                          padding: EdgeInsets.all(15),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 100,
                                crossAxisCount: 2,
                              ),
                          itemCount: filterdItems.length,
                          itemBuilder: (context, index) {
                            final doc =
                                filterdItems[index]; //getting the single item from the List<QueryDocumentSnapshot>                                 filterdItems[index]; //this is the firestore document
                            final item =
                                doc.data()
                                    as Map<
                                      String,
                                      dynamic
                                    >; // and now changing the QueryDocumentSnapshot type to Map<String,Dynamic> ready to use Map[String] = Dynamic
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
                                      child: CachedNetworkImage(
                                        imageUrl: item['image'],
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
                                            Text(
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
                                            SingleChildScrollView(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  // Text(
                                                  //   '${(filterdItems[index]['rating'] / filterdItems[index]['review']).toStringAsFixed(1)}',
                                                  //   style: GoogleFonts.lato(
                                                  //     textStyle: const TextStyle(
                                                  //       color:
                                                  //           Colors
                                                  //               .deepOrangeAccent,
                                                  //       fontWeight:
                                                  //           FontWeight.w800,
                                                  //       fontSize: 14,
                                                  //     ),
                                                  //   ),
                                                  // ),   we dont' have a rating and a review
                                                  const SizedBox(width: 4),
                                                  // Text(
                                                  //   '(${filterdItems[index]['rating'].toInt()})',
                                                  //   style: GoogleFonts.lato(
                                                  //     textStyle:
                                                  //         const TextStyle(
                                                  //           color:
                                                  //               Colors.black45,
                                                  //           fontWeight:
                                                  //               FontWeight.w800,
                                                  //           fontSize: 14,
                                                  //         ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // Product Name - Fixed word separation
                                        Text(
                                          item['name'].replaceAll(
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
                                              '\$${item['price'].toStringAsFixed(2)}',
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
                                        if (item['isDiscounted'])
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: Text(
                                              '\$${(item['price'] + 200).toStringAsFixed(2)}',
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
                        );
                      }
                      if (snapshots.hasError) {
                        return Center(child: Text('Something went wroing '));
                      }

                      return CircularProgressIndicator();
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
