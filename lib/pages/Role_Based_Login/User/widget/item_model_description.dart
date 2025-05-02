import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/app_model.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/model/category_model.dart';

class ItemModelDescription extends StatelessWidget {
  final AppModel categoryModel;
  ItemModelDescription({super.key, required this.categoryModel});

  //
  Widget build(context) {
    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Row(
              children:
                  categoryModel.size
                      .map(
                        (size) => Container(
                          margin: EdgeInsets.only(right: 7),
                          child: Text(
                            size,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: const Color.fromARGB(255, 124, 100, 10),
                                fontWeight: FontWeight.w800,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            SizedBox(width: 5),
            Row(
              children: [
                Icon(Icons.star, color: Colors.blue),
                Text(
                  (categoryModel.rating / categoryModel.review).toStringAsFixed(
                    2,
                  ),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  '(${categoryModel.rating.toInt()})',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // the name of the model
        Text(
          categoryModel.name,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 7),

        Row(
          children: [
            Text(
              '\$${categoryModel.price.toString()}',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (categoryModel.isCheck == true)
              Text('${categoryModel.price + 200}'),
          ],
        ),
      ],
    ));
  }
}
