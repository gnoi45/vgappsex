// Flutter code sample for DropdownButton

// This sample shows a `DropdownButton` with a large arrow icon,
// purple text style, and bold purple underline, whose value is one of "One",
// "Two", "Free", or "Four".
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/dropdown_button.png)

import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:e_relax_hybrid/MyOrders.dart';
import 'package:e_relax_hybrid/SearchResult.dart';
import 'package:flutter/material.dart';

import 'ServiceOrders.dart';

/// This Widget is the main application widget.
class Proxorders extends StatefulWidget {
  static const String _title = 'Search';

  @override
  State<StatefulWidget> createState() {
    return _MyStatefulWidgetState();
  }
}


int getcost()
{

}


class _MyStatefulWidgetState extends State<Proxorders> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(context, "My Orders"),
        body:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Products", style: TextStyle(fontSize: 15.0)),
                            ],
                          )),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                          return new MyOrders();
                        }));
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Service", style: TextStyle(fontSize: 15.0)),
                            ],
                          )),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                          return new ServiceOrders();
                        }));
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ],
              ));
  }
}
