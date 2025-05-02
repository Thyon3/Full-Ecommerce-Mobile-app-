import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/screen/item_details.dart';
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
  @override
  // TODO: implement widget
  Widget build(context) {
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categoriesList.length, (index) {
                    return InkWell(
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
                              backgroundImage: AssetImage(
                                categoriesList[index].imagePath,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            categoriesList[index].name,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(fullModels.length, (index) {
                    final ecommerceItem = fullModels[index];
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
                                    return ItemDetails(appModel: ecommerceItem);
                                  },
                                ),
                              );
                            },
                            child: ItemModels(
                              ecommerceItem: ecommerceItem,
                              size: size,
                            ),
                          ),

                          SizedBox(height: 7),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
