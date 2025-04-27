import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color color;
  MyElevatedButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.color,
  });

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color,
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
