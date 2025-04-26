import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mybutton extends StatelessWidget {
  Mybutton({super.key, required this.text, required this.onTap});

  final String text;
  final void Function() onTap;

  Widget build(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
