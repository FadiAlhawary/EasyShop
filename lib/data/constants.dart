import 'package:flutter/material.dart';

class KStyle{
  static const TextStyle headerTextStyle=TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    letterSpacing: 10,
    /* shadows: [Shadow(
           color: Colors.grey,
            offset: Offset(2, 2),
         blurRadius: 4
       ),] */
    color: Colors.black,
  );
  static const normalTextStyle=TextStyle(
    fontSize: 25,
    //color: Colors.black
  );
  static const errorMessageTextStyle=TextStyle(
    color: Colors.red,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  static const leadingTextStyle=TextStyle(
    color: Colors.grey,
    fontSize: 30,
  );
  static const titleTextStyle=TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,

  );
}

