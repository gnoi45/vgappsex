import 'dart:convert';

import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:e_relax_hybrid/AppUrl.dart';
import 'package:e_relax_hybrid/ProductDetails.dart';
import 'package:e_relax_hybrid/test/AppSignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

String slug;
int _state = 0;
String x_id;

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen(String x) {
    slug = x;
  }

  @override
  _ProductDetailScreenSta createState() => _ProductDetailScreenSta();
}

class _ProductDetailScreenSta extends State<ProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      int status = preferences.getInt("status");
      x_id = preferences.getString("id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: appBarWidget(context, "Product Details"),
      body: FutureBuilder(
        future: getDetails(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return createDetailView(context, snapshot);
          }
        },
      ),
      bottomNavigationBar: xyz(context),
    );
  }

  @override
  Widget xyz(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: RaisedButton(
        child: setUpButtonChild(),
        elevation: 0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            side: BorderSide(color: Colors.blue)),
        onPressed: () {
          if (x_id == null || x_id.isEmpty) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new AppSignIn();
            }));
          } else if (x_id.isNotEmpty) {
            setState(() {
              _state = 1;
            });
            addToCarts(slug, "1");
          }
        },
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }

  Future<String> addToCarts(String product_id, String quantity) async {
    final response = await http.post(
       AppUrl.ADD_CART,
        body: {
          "product_id": "" + product_id,
          "qty": "" + quantity,
          "customer_id": "" + x_id
        });

    final data = jsonDecode(response.body);
    int value = data['status'];

    if (value == 200) {
      String nameAPI = data['msg'];
      setState(() {
        _state = 0;
      });
      loginToast(nameAPI);
    } else {
      setState(() {
        _state = 0;
      });
      print("fail");
      loginToast("Some Error Occurred");
    }
  }
}

Widget setUpButtonChild() {
  if (_state == 0) {
    return new Text(
      "Add To Cart",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  } else if (_state == 1) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}

Widget createDetailView(BuildContext context, AsyncSnapshot snapshot) {
  Model values = snapshot.data;
  return DetailScreen(
    productDetails: values,
  );
}

class DetailScreen extends StatefulWidget {
  Model productDetails;

  DetailScreen({Key key, this.productDetails}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /*Image.network(
              widget.productDetails.data.productVariants[0].productImages[0]),*/
          Image.network(
            widget.productDetails.image,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//                Text("SKU".toUpperCase(),
//                    style: TextStyle(
//                        fontSize: 16,
//                        fontWeight: FontWeight.w700,
//                        color: Color(0xFF565656))),
                Text(widget.productDetails.title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFfd0100)))
//                Icon(
//                  Icons.arrow_forward_ios,
//                  color: Color(0xFF999999),
//                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Price".toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text(
                    " ${(widget.productDetails.product_sale != null) ? widget.productDetails.product_sale : "Unavailable"}"
                        .toUpperCase(),
                    style: TextStyle(
                        color: (Color(0xFF0dc2cd)),
                        fontFamily: 'Roboto-Light.ttf',
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
                Html(
                  data: widget.productDetails.long_desc,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Other Links",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
//                Column(
//                  children: generateProductSpecification(context),
//                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Ratings & Reviews",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text("5 star",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFfd0100))),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF999999),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

//  List<Widget> generateProductSpecification(BuildContext context) {
//    List<Widget> list = [];
//    int count = 0;
//    widget.productDetails.data.productSpecifications.forEach((specification) {
//      Widget element = Container(
//        height: 30,
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(specification.specificationName,
//                textAlign: TextAlign.left,
//                style: TextStyle(
//                    fontSize: 14,
//                    fontWeight: FontWeight.w400,
//                    color: Color(0xFF444444))),
//            Text(specification.specificationValue,
//                textAlign: TextAlign.left,
//                style: TextStyle(
//                    fontSize: 14,
//                    fontWeight: FontWeight.w400,
//                    color: Color(0xFF212121))),
//          ],
//        ),
//      );
//      list.add(element);
//      count++;
//    });
//    return list;
//  }
}

class Model {
  String title;
  String image;
  String long_desc;
  String product_sale;

  Model(this.title, this.image, this.long_desc, this.product_sale);
}

Future<Model> getDetails() async {
  final response = await http.post(
      AppUrl.PRODUCT_DETAILS,
      body: {"product_id": "" + slug});

  final data = jsonDecode(response.body);
  int value = data['status'];

  if (value == 200) {
    String product_sale_price = data['msg']['product_sale_price'];
    String long_description = data['msg']['long_description'];
    String nameAPI = data['msg']['product_title'];
    String id = data['msg']['productID'];
    String image = data['msg']['image'];

//    loginToast(nameAPI);
    return Model(nameAPI, image, long_description, product_sale_price);
  } else {
    print("fail");
    loginToast("Some Error Occurred");
    return Model("", "", "", "");
  }
}

loginToast(String toast) {
  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}
