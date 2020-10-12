import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_relax_hybrid/AppUrl.dart';
import 'package:http/http.dart' as http;
import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Address.dart';
import 'Services.dart';

String xx_id="";

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.post(
      AppUrl.GET_ALL_ADDRESS,
      body: {"user_id": ""+xx_id});

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  print("Respnse" + responseBody);

  final parsed1 = jsonDecode(responseBody);
  final parsed = parsed1["msg"].cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class AllAddress extends StatefulWidget {



  @override
  Orderx createState() => Orderx();
}

class Orderx extends State<AllAddress> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      int status = preferences.getInt("status");
      xx_id = preferences.getString("id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:   AppBar(
        // Provide a standard title.
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.blue),
        title: Text('Address',
            style: TextStyle(
                color: Colors.blue, fontFamily: 'Roboto-Light.ttf')),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new Address();
                  }));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? _FoodOrderPageState(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Photo {
  final String plot_no;
  final String street;
  final String area;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final String country;

  Photo(
      {this.plot_no, this.street, this.area, this.city, this.state,this.pincode,this.landmark,this.country});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      plot_no: json['plot_no'] as String,
      street: json['street'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      landmark: json['landmark'] as String,
      country: json['country'] as String
    );
  }
}

class _FoodOrderPageState extends StatelessWidget {
  final List<Photo> photos;

  _FoodOrderPageState({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: photos.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    height: 150.0,
                    child: CartItem(
                        productName: ""+i.plot_no,
                        productPrice: ""+i.street+","+i.city,
                        productCartQuantity: i.state+","+i.pincode),

                  );
                },
              );
            }).toList(),
          ),
        ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 10),
              //   child: ButtonTheme(
              //     buttonColor: Theme.of(context).primaryColor,
              //     minWidth: double.infinity,
              //     height: 40.0,
              //     child: RaisedButton(
              //       onPressed: () {
              //       },
              //       child: Text(
              //         "Add Address",
              //         style: TextStyle(color: Colors.white, fontSize: 16),
              //       ),
              //     ),
              //   ),
              // ),
           );
  }
}

class CartItem extends StatelessWidget {
  String productName;
  String productPrice;
  String productImage;
  String productCartQuantity;

  CartItem({
    Key key,
    @required this.productName,
    @required this.productPrice,
    @required this.productImage,
    @required this.productCartQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "$productName",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "$productPrice",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child:Text(
                        "$productCartQuantity",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF3a3a3b),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

