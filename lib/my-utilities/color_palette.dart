import 'package:flutter/widgets.dart';

class MyColorPalette {
  // static final  int premiumColor = 0xFF6200EE; // Purple
  // static final int permium

  //// regular colors
  static final Color bgGrey = Color.fromARGB(255, 217, 217, 217);
  static final Color txtFieldGrey = Color.fromARGB(255, 240, 240, 240);

  static final Color emergencyStopOutLine = Color.fromARGB(255, 207, 158, 105);
  static final Color emergencyStopFill = Color.fromARGB(255, 232, 210, 159);

  static final Color txtColor = Color.fromARGB(255, 17, 17, 17);
  static final Color goButton = Color.fromARGB(255, 234, 146, 52);

  static List<Color> inUse = premiumColor;

  //// 60,30,10 rule
  static final List<Color> premiumColor = [
    Color.fromARGB(255, 255, 103, 103),
    Color.fromARGB(255, 209, 107, 107),
    Color.fromARGB(255, 249, 96, 96),
    ////
    //// unselected color
    Color.fromARGB(255, 126, 43, 43),
  ];

  //// 60,30,10 rule
  static final List<Color> regularColor = [
    Color.fromARGB(255, 104, 226, 104),
    Color.fromARGB(255, 62, 186, 62),
    Color.fromARGB(255, 50, 255, 50),
    //// unselected color
    Color.fromARGB(255, 59, 116, 59),
  ];

  //// 60,30,10 rule
  static final List<Color> dieselColor = [
    Color.fromARGB(255, 95, 151, 255),
    Color.fromARGB(255, 68, 115, 255),
    Color.fromARGB(255, 48, 155, 255),
    //// unselected color
    Color.fromARGB(255, 61, 115, 166),
  ];
}
