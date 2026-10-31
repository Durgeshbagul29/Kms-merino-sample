// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


//For cards
Widget headingText(String str) {

    return Text(
      str,
      style: TextStyle(fontSize: 15,color: Colors.black87)
    );
}

Widget subHeadingText(String str) {

    return Text(
      str,
      style: TextStyle(fontSize: 12,color: Colors.grey[600]),
    );
}

Widget descText(String str) {

    return Text(
      str,
      style: TextStyle(fontSize: 14,color: Colors.grey[700]),
      maxLines: 2,
      overflow:TextOverflow.ellipsis,
    );
}

Widget statusText(String str,Color color) {

    return Text(
      str,
      style: TextStyle(fontSize: 14,color: color),
    );
}

//For ListTiles
Widget tileHeadingText(String str) {

    return Text(
      str,
      style: TextStyle(fontSize: 15,color: Colors.black87)
    );
}

Widget tileDescText(String str) {

    return Text(
      str,
      style: TextStyle(fontSize: 14,color: Colors.grey[700]),
    );
}

//for broadcast and archieve files
Widget listtileHeadingText(String str) {

    return Text(
      str,
      style: TextStyle(fontSize: 15,color: Colors.black87)
    );
}

Widget listtileHeadingText1(String str) {

    return Text(
      str,
      style: TextStyle(fontSize: 15,color: Colors.grey[600]),
    );
}