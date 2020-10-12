import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:flutter/material.dart';

class Contactus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Contactu();
  }
}

class Contactu extends State<Contactus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, "Contact Us"),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '',
            ),
          ],
        ),
      ),
    );
  }
}