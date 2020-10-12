import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'AppBar/AppBarWidget.dart';
import 'Services.dart';
import 'getAllServices.dart';

class LocationSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationS();
  }
}
Position _current;
class LocationS extends State<LocationSearch> {
  String defaultFontFamily = 'Roboto-Light.ttf';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context,"Location"),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hi Nice to Meet You',
              style: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'See services around',
              style: TextStyle(
                color: Colors.black,
                fontFamily: defaultFontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 15,
            ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child:
            RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Your Current Location", style: TextStyle(fontSize: 20.0)),
                      ],
                    )),
                onPressed: () {

                  _getCurrentLocation();
                 Navigator.of(context)
                     .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                   return new getAllServices();
                 }));
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))),
        ),
//         Container(
//           margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
//           child:
//             RaisedButton(
//                 color: Colors.white,
//                 textColor: Colors.blue,
//                 child: Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         Text("Some Other Location", style: TextStyle(fontSize: 20.0)),
//                       ],
//                     )),
//                 onPressed: () {
// //                  Navigator.of(context)
// //                      .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
// //                    return new SearchResult(myController.text);
// //                  }));
//                 },
//                 shape: new RoundedRectangleBorder(
//                     borderRadius: new BorderRadius.circular(10.0))),
//         ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _current = position;
        print(_current.latitude.toString()+""+_current.longitude.toString());
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(_current.latitude.toString() + " "+_current.longitude.toString()), duration: Duration(seconds: 1)));
      });
    }).catchError((e) {
      print(e);
    });
  }
}