import 'package:flutter/material.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class ItemDetails extends StatelessWidget {
  final AppModel appModel;
  ItemDetails({super.key, required this.appModel});

  Widget build(context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
        padding: EdgeInsets.only(top: 30),
        height: size.height * 0.6,
        width: size.width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(40, 228, 228, 235),
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: AssetImage(appModel.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
