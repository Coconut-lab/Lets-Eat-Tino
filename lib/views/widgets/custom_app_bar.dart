import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar {
  static AppBar defaultAppBar() {
    return AppBar(
      toolbarHeight: 100,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'assets/LetsEatTino.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '000님 환영해요!',
                  style: GoogleFonts.doHyeon(
                    textStyle: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                SizedBox(height: 0),
                Image.asset(
                  'assets/User1.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static AppBar userScreenAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      toolbarHeight: 100,
      elevation: 0,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          Image.asset(
            'assets/LetsEatTino.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
