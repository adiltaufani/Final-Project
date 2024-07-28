import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataEmpty extends StatelessWidget {
  const DataEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 50.0,
              color: Colors.black26,
            ),
            SizedBox(height: 10.0),
            Text(
              "There are no properties on this list yet",
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  color: Colors.black26,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.6,
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
