import 'package:flutter/material.dart';

Widget appBarWidget(context,titl) {
  return AppBar(
    elevation: 1.0,
    centerTitle: true,
    backgroundColor: Colors.white,
    iconTheme: new IconThemeData(color: Colors.blue),
    title: Text(titl ,style: TextStyle(
        color: Colors.blue,
        fontFamily: 'Roboto-Light.ttf')),
  );
}
