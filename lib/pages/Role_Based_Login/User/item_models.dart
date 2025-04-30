import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';

class ItemModels extends StatelessWidget {
  final AppModel ecommerceItem;
  final Size size;

  ItemModels({super.key, required this.ecommerceItem, required this.size});
  Widget build(context) {
    return Column(
      children: [
        Container(
          height: size.height * 0.25,
          width: size.width * 0.5,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 134, 155, 177),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(ecommerceItem.image),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: const Color.fromARGB(255, 250, 231, 231),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.star_outline, size: 30, color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
