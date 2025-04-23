import 'package:flutter/material.dart';
 class KConstants{
   static const String userNameConstant='userNameConstant';
   static const String imageURLConstant='imageURLConstant';
   static const String lightModeSwitchConstant='lightModeSwitchConstant';
 }
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
    fontSize: 15,
    //color: Colors.black
  );
  static const errorMessageTextStyle=TextStyle(
    color: Colors.red,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );
  static const leadingTextStyle=TextStyle(
    color: Colors.grey,
    fontSize: 20,
  );
  static const titleTextStyle=TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,

  );
}

