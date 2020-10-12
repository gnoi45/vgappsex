import 'package:flutter/material.dart';

import 'AppBar/AppBarWidget.dart';

class Terms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Term();
  }
}

class Term extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context,"Terms & Conditions"),
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