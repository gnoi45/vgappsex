import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_relax_hybrid/AppUrl.dart';
import 'package:http/http.dart' as http;
import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services.dart';

String xx_id="";

Future<List<Photox>> fetchPhotos(http.Client client) async {
  final response = await client.post(
      AppUrl.ORDER_URL,
      body: {"cust_id": ""+xx_id});

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photox> parsePhotos(String responseBody) {
  print("Respnse" + responseBody);

  final parsed1 = jsonDecode(responseBody);

  final parsed2= parsed1["msg"]["services"].cast<Map<String, dynamic>>();

  return parsed2.map<Photox>((json) => Photox.fromJson(json)).toList();
}

class ServiceOrders extends StatefulWidget {



  @override
  Orderx createState() => Orderx();
}

class Orderx extends State<ServiceOrders> {
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
      appBar: appBarWidget(context, "Service Orders"),
      body: FutureBuilder<List<Photox>>(
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
  final String name;
  final String id;
  final String profile_pic;
  final String long_desc;
  final String sale_price;

  Photo(
      {this.name, this.id, this.long_desc, this.profile_pic, this.sale_price});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['order_status'] as String,
      id: json['order_id'] as String,
      long_desc: json['created_at'] as String,
      profile_pic: json['payment_status'] as String,
      sale_price: json['amount'] as String,
    );
  }
}

class Photox {
  final String name;
  final String id;
  final String profile_pic;
  final String long_desc;
  final String sale_price;

  Photox(
      {this.name, this.id, this.long_desc, this.profile_pic, this.sale_price});

  factory Photox.fromJson(Map<String, dynamic> json) {
    return Photox(
      name: json['order_status'] as String,
      id: json['service_id'] as String,
      long_desc: json['created_at'] as String,
      profile_pic: json['payment_status'] as String,
      sale_price: json['price'] as String,
    );
  }
}

class _FoodOrderPageState extends StatelessWidget {
  final List<Photox> photos;

  _FoodOrderPageState({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: photos.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    height: 150.0,
                    child: CartItem(
                        productName: ""+i.id,
                        productPrice: "\$"+i.sale_price,
                        productImage: ""+i.name,
                        productCartQuantity: i.long_desc),

                  );
                },
              );
            }).toList(),
          ),
        ));
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
                // Container(
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Center(
                //         child: CachedNetworkImage(
                //           imageUrl: productImage,
                //       width: 110,
                //       height: 100,
                //     )),
                //   ),
                // ),
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
                                "Order No : $productName",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "amount: $productPrice",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 10),
                              child:Text(
                                "Date : $productCartQuantity",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 10),
                              child:Text(
                                "Status : $productImage",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

