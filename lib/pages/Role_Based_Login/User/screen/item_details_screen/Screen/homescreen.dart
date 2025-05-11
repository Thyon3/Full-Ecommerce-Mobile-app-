import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/screen/item_details_screen/Screen/category_itmes.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/screen/item_details_screen/Screen/item_details.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/widget/item_model_description.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/widget/my_banner.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/widget/item_models.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/category_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: implement widget

  Widget build(context) {
    // now we will catch the category collection which contains the name and the image of each category which are uploaded by the admin
    CollectionReference cetegoriesListFirestore = FirebaseFirestore.instance
        .collection('Category');

    CollectionReference itemsList = FirebaseFirestore.instance.collection(
      'items',
    ); //the colletction of the items uploded by the admin
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/Logo/image.png',
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error loading image: $error');
                        return Icon(Icons.error);
                      },
                    ),
                    Stack(
                      children: [
                        Icon(Icons.shopping_bag, size: 40, color: Colors.black),
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
                  ],
                ),
              ),
              // lets have  a banner widget here
              SizedBox(height: 10),
              MyBanner(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shop By Category',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Show All..',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              StreamBuilder(
                stream: cetegoriesListFirestore.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (snapshots.hasData) {
                    final item = snapshots.data!.docs;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(item.length, (index) {
                          final firstDoc = item[index];
                          return InkWell(
                            onTap: () {
                              // // filter the list of the AppModel with the cateory selected
                              // final filteredItems =
                              //     fullModels
                              //         .where(
                              //           (item) =>
                              //               item.category.toLowerCase() ==
                              //               categoriesList[index].name
                              //                   .toLowerCase(),
                              //         )
                              //         .toList();

                              // Now navagate to the screen where you can get the list of the items with
                              // the category selected. so i am passing the filtered list and th category name

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CategoryItems(
                                        selectedCategory: firstDoc['name'],
                                      ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: const Color.fromARGB(
                                      244,
                                      162,
                                      180,
                                      139,
                                    ),
                                    backgroundImage: NetworkImage(
                                      snapshots.data!.docs[index]['image'],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  snapshots.data!.docs[index]['name'],
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  }
                  if (snapshots.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong ... Please try again later',
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Curated For You',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Show All..',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              StreamBuilder(
                stream: itemsList.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (snapshots.hasData) {
                    final doc = snapshots.data!.docs;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(doc.length, (index) {
                          final ecommerceItem = doc[index];
                          final item =
                              ecommerceItem.data() as Map<String, dynamic>;
                          return Padding(
                            padding:
                                index == 0
                                    ? EdgeInsets.only(left: 10, right: 20)
                                    : EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ItemDetails(appModel: item);
                                        },
                                      ),
                                    );
                                  },
                                  child: ItemModels(
                                    ecommerceItem: item,
                                    size: size,
                                  ),
                                ),

                                SizedBox(height: 25),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  }
                  if (snapshots.hasError) {
                    return Center(child: Text('something went wrong'));
                  }
                  if (!snapshots.hasData) {
                    return CircularProgressIndicator();
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
